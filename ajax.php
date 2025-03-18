<?php
use WHMCS\Database\Capsule;

require_once __DIR__ . '/../../../init.php';
require_once __DIR__ . '/../../../includes/functions.php';

function apiRequest($url, $method, $data = null) {
    $api_key = "YOUR_PATHNET_API_KEY_HERE";
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        "Authorization: Bearer " . $api_key
    ]);
    if ($method == "POST") {
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    } elseif ($method == "DELETE") {
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
    }
    $response = curl_exec($ch);
    if (curl_errno($ch)) {
        error_log("cURL error in apiRequest: " . curl_error($ch));
    }
    curl_close($ch);
    return json_decode($response, true);
}

function getFirewallRules($ip) {
    $url = "https://api.path.net/v2/rules?page=1&size=100&destination=$ip";
    return apiRequest($url, "GET");
}

function addFirewallRule($rule_data) {
    $url = "https://api.path.net/v2/rules";
    return apiRequest($url, "POST", json_encode($rule_data));
}

function deleteFirewallRule($rule_id) {
    $url = "https://api.path.net/v2/rules/$rule_id";
    return apiRequest($url, "DELETE");
}

function getFilters() {
    $url = "https://api.path.net/filters/available";
    return apiRequest($url, "GET");
}

function addFilter($filter_data) {
    $filter_name = $filter_data['name'];
    $url = "https://api.path.net/filters/$filter_name";
    $data_to_send = [];
    foreach ($filter_data as $key => $value) {
        if ($key !== 'name') {
            $data_to_send[$key] = empty($value) ? null : $value;
        }
    }
    return apiRequest($url, "POST", json_encode($data_to_send));
}

function deleteFilter($filter_id, $filter_name) {
    $url = "https://api.path.net/filters/$filter_name/$filter_id";
    return apiRequest($url, "DELETE");
}

function getCurrentFilters($ip) {
    $url = "https://api.path.net/filters?addr=$ip";
    return apiRequest($url, "GET");
}

function getAttackHistory($ip) {
    $url = "https://api.path.net/attack_history?host=$ip";
    return apiRequest($url, "GET");
}

function verifyIpOwnership($userId, $ip) {
    $command = 'GetClientsProducts';
    $postData = [
        'clientid' => $userId,
        'stats'    => true,
    ];
    $results = localAPI($command, $postData);
    if ($results['result'] === 'success') {
        foreach ($results['products']['product'] as $product) {
            if (strtolower($product['status']) !== 'active') {
                continue;
            }
            $dedicatedIp = trim($product['dedicatedip']);
            $assignedIps = array_map('trim', explode(',', $product['assignedips']));
            if ($ip === $dedicatedIp || in_array($ip, $assignedIps)) {
                return true;
            }
        }
    }
    return false;
}

header('Content-Type: application/json; charset=utf-8');

$clientId = isset($_SESSION['uid']) ? (int) $_SESSION['uid'] : 0;
if (!$clientId) {
    echo json_encode(['error' => 'Unauthorized: no active WHMCS session']);
    exit;
}

$action = isset($_REQUEST['action']) ? $_REQUEST['action'] : null;
$ip     = isset($_REQUEST['ip'])     ? $_REQUEST['ip']     : null;

if (!$action) {
    echo json_encode(['error' => 'No action specified.']);
    exit;
}
if (!$ip) {
    echo json_encode(['error' => 'No IP specified.']);
    exit;
}

if (!verifyIpOwnership($clientId, $ip)) {
    echo json_encode(['error' => 'Not authorized to manage this IP.']);
    exit;
}

switch ($action) {
    case 'getRules':
        $rules = getFirewallRules($ip);
        echo json_encode($rules);
        break;

    case 'addRule':
        $rule_data = isset($_REQUEST['ruleData']) ? $_REQUEST['ruleData'] : [];
        if (isset($rule_data['destination']) && $rule_data['destination'] === $ip) {
            $res = addFirewallRule($rule_data);
            echo json_encode($res);
        } else {
            echo json_encode(['error' => 'Destination IP does not match requested IP.']);
        }
        break;

    case 'deleteRule':
        $rule_id = isset($_REQUEST['ruleId']) ? $_REQUEST['ruleId'] : null;
        if ($rule_id) {
            $res = deleteFirewallRule($rule_id);
            echo json_encode($res);
        } else {
            echo json_encode(['error' => 'No ruleId specified.']);
        }
        break;

    case 'getFilters':
        $res = getFilters();
        echo json_encode($res);
        break;

    case 'addFilter':
        $filter_data = isset($_REQUEST['filterData']) ? $_REQUEST['filterData'] : [];
        if (isset($filter_data['addr']) && $filter_data['addr'] === $ip) {
            $res = addFilter($filter_data);
            echo json_encode($res);
        } else {
            echo json_encode(['error' => 'Filter IP does not match requested IP.']);
        }
        break;

    case 'getCurrentFilters':
        $res = getCurrentFilters($ip);
        echo json_encode($res);
        break;

    case 'deleteFilter':
        $filter_id   = isset($_REQUEST['filterId'])   ? $_REQUEST['filterId']   : null;
        $filter_name = isset($_REQUEST['filterName']) ? $_REQUEST['filterName'] : null;
        if ($filter_id && $filter_name) {
            $res = deleteFilter($filter_id, $filter_name);
            echo json_encode($res);
        } else {
            echo json_encode(['error' => 'Missing filterId or filterName.']);
        }
        break;

    case 'attackHistory':
        $res = getAttackHistory($ip);
        echo json_encode($res);
        break;

    default:
        echo json_encode(['error' => 'Invalid action.']);
        break;
}
exit;
