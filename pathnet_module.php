<?php
if (!defined("WHMCS")) {
    die("Direct access not allowed.");
}

function pathnet_module_config() {
    return [
        'name'        => 'PathNet Module',
        'description' => 'Module to manage PathNet in the Client Area.',
        'version'     => '1.0',
        'author'      => 'Hostealo.es',
        'language'    => 'spanish',
    ];
}

function pathnet_module_activate() {
    return [
        'status'      => 'success',
        'description' => 'PathNet Module activated successfully.',
    ];
}

function pathnet_module_deactivate() {
    return [
        'status'      => 'success',
        'description' => 'PathNet Module deactivated successfully.',
    ];
}

function pathnet_module_clientarea($vars) {

    $clientId = isset($_SESSION['uid']) ? (int) $_SESSION['uid'] : 0;
    $services = [];

    if ($clientId) {
        $command  = 'GetClientsProducts';
        $postData = [
            'clientid' => $clientId,
            'stats'    => true,
        ];
        $results = localAPI($command, $postData);
        if ($results['result'] === 'success') {
            $ipSet = [];

            foreach ($results['products']['product'] as $prod) {
                if (strtolower($prod['status']) !== 'active') {
                    continue;
                }

                $hostname = !empty($prod['domain']) ? $prod['domain'] : 'No hostname';

                if (!empty($prod['dedicatedip'])) {
                    $ip = trim($prod['dedicatedip']);
                    if (strpos($ip, '45') === 0 && !isset($ipSet[$ip])) {
                        $services[] = ['ip' => $ip, 'hostname' => $hostname];
                        $ipSet[$ip] = true;
                    }
                }

                if (!empty($prod['assignedips'])) {
                    $extraIps = explode(',', $prod['assignedips']);
                    foreach ($extraIps as $ipVal) {
                        $ip = trim($ipVal);
                        if (strpos($ip, '45') === 0 && !isset($ipSet[$ip])) {
                            $services[] = ['ip' => $ip, 'hostname' => $hostname];
                            $ipSet[$ip] = true;
                        }
                    }
                }
            }
        }

    }

    $language = $_SESSION['Language'];

    $availableLanguages = ['spanish', 'english'];

    if (!in_array($language, $availableLanguages)) {
        $language = 'english';
    }

    include __DIR__ . '/lang/' . $language . '.php';


    return [
        'pagetitle'    => 'Firewall Management - Path.net',
        'breadcrumb'   => [
            'index.php?m=pathnet_module' => 'PathNet Module',
        ],
        'templatefile' => 'overview',
        'requirelogin' => true,
        'vars'         => [
            'services' => $services,
            'clientId' => $clientId,
            'langModule'     => $_ADDONLANG,
        ],
    ];
}
