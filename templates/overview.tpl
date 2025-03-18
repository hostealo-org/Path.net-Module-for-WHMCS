<!-- Toastr CSS for notifications -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>

<!-- IP Selector -->
<div class="row mb-3">
    <div class="col-sm-12">
        <div class="card">
            <div class="ticket-reply">
                <div class="ticket-reply-top">
                    <div class="user">
                        <div class="user-info">
                            <span class="name">
                                <i class="fas fa-network-wired"></i>
                                {$langModule.selectIpToEdit}
                            </span>
                        </div>
                    </div>
                </div>
                <div class="ticket-reply-message markdown-content">
                    <select id="ipSelector" class="form-control" style="max-width: 300px;">
                        {foreach from=$services item=service}
                            <option value="{$service.ip}">{$service.ip} - {$service.hostname}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Main Firewall Block with Tabs -->
<div class="row">
    <div class="col-sm-12">
        <div class="card mb-3">
            <div class="ticket-reply">
                <div class="ticket-reply-top">
                    <div class="user">
                        <div class="user-info">
                            <span class="name">
                                <i class="fas fa-shield"></i>
                                {$langModule.firewallTitle}
                            </span>
                        </div>
                        <div class="date" style="align-self: auto;">
                            <img src="/modules/addons/pathnet_module/templates/path_logo.png" width="80px">
                        </div>
                    </div>
                </div>
                <div class="ticket-reply-message markdown-content">
                    <!-- Tab Navigation -->
                    <ul class="nav nav-tabs" id="firewallTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="reglasFirewall-tab" data-toggle="tab" href="#reglasFirewall" role="tab" aria-controls="reglasFirewall" aria-selected="true">
                                {$langModule.firewallRules}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="filtros-tab" data-toggle="tab" href="#filtros" role="tab" aria-controls="filtros" aria-selected="false">
                                {$langModule.filters}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="historial-tab" data-toggle="tab" href="#historial" role="tab" aria-controls="historial" aria-selected="false">
                                {$langModule.attackHistory}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="predefinidos-tab" data-toggle="tab" href="#predefinidos" role="tab" aria-controls="predefinidos" aria-selected="false">
                                {$langModule.predefinedRules}
                            </a>
                        </li>
                    </ul>

                    <!-- Tab Content -->
                    <div class="tab-content" id="myTabContent">
                        <!-- Firewall Rules Tab -->
                        <div class="tab-pane fade show active" id="reglasFirewall" role="tabpanel" aria-labelledby="reglasFirewall-tab">
                            <!-- Sub-tab: Add Rule -->
                            <ul class="nav nav-tabs" id="reglasSubTabs" role="tablist">
                                <li class="nav-item ml-auto">
                                    <a class="nav-link small" id="nuevaRegla-tab" data-toggle="tab" href="#nuevaRegla" role="tab" aria-controls="nuevaRegla" aria-selected="true">
                                        <i class="fas fa-plus"></i> {$langModule.addRule}
                                    </a>
                                </li>
                            </ul>
                            <div class="tab-content" id="nuevaReglaContent">
                                <div class="tab-pane fade" id="nuevaRegla" role="tabpanel" aria-labelledby="nuevaRegla-tab">
                                    <div class="card mb-3">
                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <form id="addFirewallRuleForm">
                                                    <div class="form-row">
                                                        <div class="col-md-2">
                                                            <label for="source">Source</label>
                                                            <input type="text" id="source" class="form-control" placeholder="0.0.0.0/0" value="0.0.0.0/0" required>
                                                        </div>
                                                        <input type="hidden" id="destination" />
                                                        <div class="col-md-2">
                                                            <label for="protocol">{$langModule.protocol}</label>
                                                            <select id="protocol" class="form-control">
                                                                <option value="tcp">TCP</option>
                                                                <option value="udp">UDP</option>
                                                                <option value="icmp">ICMP</option>
                                                                <option value="">Any</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-2">
                                                            <label for="dstPort">{$langModule.dstPort}</label>
                                                            <input type="text" id="dstPort" class="form-control" placeholder="22">
                                                        </div>
                                                        <div class="col-md-2">
                                                            <label for="srcPort">{$langModule.srcPort}</label>
                                                            <input type="text" id="srcPort" class="form-control" placeholder="">
                                                        </div>
                                                        <div class="col-md-2">
                                                            <label for="actionType">{$langModule.actionType}</label>
                                                            <select id="actionType" class="form-control">
                                                                <option value="whitelist">Whitelist</option>
                                                                <option value="block">Block</option>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <label for="comment">{$langModule.comment}</label>
                                                            <input type="text" id="comment" class="form-control" placeholder="{$langModule.ruleDescriptionPlaceholder}">
                                                        </div>
                                                    </div>
                                                    <button type="submit" id="addRuleButton" class="btn btn-primary mt-3">
                                                        <i class="fas fa-plus"></i> {$langModule.addRule}
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="tableLoadingIndicator" class="text-center my-3"></div>
                            <table class="table table-striped" id="firewallRulesTable">
                                <thead>
                                <tr>
                                    <th>{$langModule.source}</th>
                                    <th>{$langModule.destination}</th>
                                    <th>{$langModule.protocol}</th>
                                    <th>{$langModule.dstPort}</th>
                                    <th>{$langModule.srcPort}</th>
                                    <th>{$langModule.ruleType}</th>
                                    <th>{$langModule.comment}</th>
                                    <th>{$langModule.actions}</th>
                                </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>

                        <!-- Filters Tab -->
                        <div class="tab-pane fade" id="filtros" role="tabpanel" aria-labelledby="filtros-tab">
                            <ul class="nav nav-tabs" id="filtrosSubTabs" role="tablist">
                                <li class="nav-item ml-auto">
                                    <a class="nav-link small" id="nuevoFiltro-tab" data-toggle="tab" href="#nuevoFiltro" role="tab" aria-controls="nuevoFiltro" aria-selected="true">
                                        <i class="fas fa-plus"></i> {$langModule.addFilter}
                                    </a>
                                </li>
                            </ul>
                            <div class="tab-content" id="myTabContent">
                                <div class="tab-pane fade" id="nuevoFiltro" role="tabpanel" aria-labelledby="nuevoFiltro-tab">
                                    <div class="card mb-3">
                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <form id="addFilterForm">
                                                    <div class="form-group">
                                                        <label for="filterType">{$langModule.selectFilter}</label>
                                                        <select id="filterType" class="form-control" required>
                                                            <option value="">{$langModule.selectFilterOption}</option>
                                                        </select>
                                                    </div>
                                                    <div id="filterFieldsContainer"></div>
                                                    <button type="submit" id="addFilterButton" class="btn btn-primary mt-3">
                                                        <i class="fas fa-plus"></i> {$langModule.addFilter}
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="filterTableLoadingIndicator" class="text-center my-3"></div>
                            <table class="table table-striped" id="filtersTable">
                                <thead>
                                <tr>
                                    <th>{$langModule.name}</th>
                                    <th>{$langModule.ipSubnet}</th>
                                    <th>{$langModule.port}</th>
                                    <th>{$langModule.extra}</th>
                                    <th>{$langModule.actions}</th>
                                </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>

                        <!-- Attack History Tab -->
                        <div class="tab-pane fade" id="historial" role="tabpanel" aria-labelledby="historial-tab">
                            <div id="attackLoadingIndicator" class="text-center my-3"></div>
                            <table class="table table-striped" id="attackHistoryTable">
                                <thead>
                                <tr>
                                    <th>{$langModule.host}</th>
                                    <th>{$langModule.reason}</th>
                                    <th>{$langModule.start}</th>
                                    <th>{$langModule.end}</th>
                                    <th>{$langModule.peakPackets}</th>
                                    <th>{$langModule.peakBytes}</th>
                                </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>

                        <!-- Predefined Rules Tab -->
                        <div class="tab-pane fade" id="predefinidos" role="tabpanel" aria-labelledby="predefinidos-tab">
                            <div class="card mb-3">
                                <div class="ticket-reply">
                                    <div class="ticket-reply-message markdown-content">
                                        <form id="predefinedRulesForm">
                                            <div class="form-group">
                                                <label for="predefinedRule">{$langModule.selectPredefinedRule}</label>
                                                <select id="predefinedRule" class="form-control">
                                                    <option value="">{$langModule.selectPredefinedOption}</option>
                                                    <option value="ssh">SSH</option>
                                                    <option value="rdp">RDP</option>
                                                    <option value="icmp">ICMP</option>
                                                    <option value="web">Web</option>
                                                    <option value="vestacp">VestaCP</option>
                                                    <option value="plesk">Plesk</option>
                                                    <option value="minecraft">Minecraft</option>
                                                    <option value="rust">Rust</option>
                                                </select>
                                            </div>
                                            <div id="ruleDescription" class="alert alert-info" style="display: none; font-size:14px;"></div>
                                            <button type="button" id="applyPredefinedRuleButton" class="btn btn-primary mt-3">
                                                {$langModule.apply}
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Toastr JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<script>
    var LANG = {
        successTitle: "{$langModule.successTitle}",
        errorTitle: "{$langModule.errorTitle}",
        loading: "{$langModule.loading}",
        ruleAdded: "{$langModule.ruleAdded}",
        ruleAddError: "{$langModule.ruleAddError}",
        ruleDeleted: "{$langModule.ruleDeleted}",
        ruleDeleteError: "{$langModule.ruleDeleteError}",
        filterAdded: "{$langModule.filterAdded}",
        filterAddError: "{$langModule.filterAddError}",
        filterDeleted: "{$langModule.filterDeleted}",
        filterDeleteError: "{$langModule.filterDeleteError}",
        confirmDeleteRule: "{$langModule.confirmDeleteRule}",
        confirmDeleteFilter: "{$langModule.confirmDeleteFilter}",
        errorLoadingRules: "{$langModule.errorLoadingRules}",
        errorLoadingFilters: "{$langModule.errorLoadingFilters}",
        errorFetchingHistory: "{$langModule.errorFetchingHistory}",
        selectFilterError: "{$langModule.selectFilterError}",
        selectPredefinedRuleError: "{$langModule.selectPredefinedRuleError}",
        predefinedRuleSSHDesc: "{$langModule.predefinedRuleSSHDesc}",
        predefinedRuleRDPDesc: "{$langModule.predefinedRuleRDPDesc}",
        predefinedRuleICMPDesc: "{$langModule.predefinedRuleICMPDesc}",
        predefinedRuleWebDesc: "{$langModule.predefinedRuleWebDesc}",
        predefinedRuleVestaCPDesc: "{$langModule.predefinedRuleVestaDesc}",
        predefinedRuleRustDesc: "{$langModule.predefinedRuleRustDesc}",
        predefinedRulePleskDesc: "{$langModule.predefinedRulePleskDesc}",
        predefinedRuleMinecraftDesc: "{$langModule.predefinedRuleMinecraftDesc}",
        noFirewallRules: "{$langModule.noFirewallRules}",
        noFilters: "{$langModule.noFilters}",
        noAttackData: "{$langModule.noAttackData}",
        selectFilterOption: "{$langModule.selectFilterOption}",
        ruleDescriptionPlaceholder: "{$langModule.ruleDescriptionPlaceholder}",
        noComment: "{$langModule.noComment}",
        delete: "{$langModule.delete}",

    };
</script>

<script>
{literal}
$(document).ready(function() {
    fetchFirewallRules();
    fetchCurrentFilters();
    fetchAttackHistory();
    getFilters();

    $("#ipSelector").change(function() {
        fetchFirewallRules();
        fetchCurrentFilters();
        fetchAttackHistory();
    });

    $("#addFirewallRuleForm").submit(function(e) {
        e.preventDefault();
        addFirewallRule();
    });

    $(document).on("click", ".delete-rule", function() {
        const ruleId = $(this).data("rule-id");
        deleteFirewallRule(ruleId, $(this));
    });

    $("#addFilterForm").submit(function(e) {
        e.preventDefault();
        addFilter();
    });

    $(document).on("click", ".delete-filter", function() {
        const filterId = $(this).data("filter-id");
        const filterName = $(this).data("filter-name");
        deleteFilter(filterId, filterName, $(this));
    });

    $("#predefinedRule").change(updateRuleDescription);
    $("#applyPredefinedRuleButton").click(applyPredefinedRule);
});

function getSelectedIp() {
    return $("#ipSelector").val() || "";
}

function fetchFirewallRules() {
    const ip = getSelectedIp();
    const $tbody = $("#firewallRulesTable tbody");
    const $loadingIndicator = $("#tableLoadingIndicator");

    $loadingIndicator.html('<i class="fas fa-spinner fa-spin"></i> ' + LANG.loading);
    $tbody.empty();

    $.post("/modules/addons/pathnet_module/ajax.php", {
        action: "getRules",
        ip
    }, function(response) {
        let data = [];
        try {
            data = (typeof response === "string") ? JSON.parse(response).data : response.data;
        } catch (e) {
            console.error("Error parsing rules response:", e);
        }

        if (data && data.length > 0) {
            data.forEach(rule => {
                const protocol = rule.protocol || "Any";
                const dstPort = rule.dst_port || "Any";
                const srcPort = rule.src_port || "Any";
                const type = rule.whitelist ? "Allow" : "Deny";
                const comment = rule.comment || LANG.noComment;
                const tr = `
    <tr>
        <td>${rule.source}</td>
        <td>${rule.destination}</td>
        <td>${protocol}</td>
        <td>${dstPort}</td>
        <td>${srcPort}</td>
        <td>${type}</td>
        <td>${comment}</td>
        <td>
            <button class="btn btn-danger btn-sm delete-rule" data-rule-id="${rule.id}">
                <i class="fas fa-trash-alt"></i> ${LANG.delete}
            </button>
        </td>
    </tr>
    `;
                $tbody.append(tr);
            });
        } else {
            $tbody.html(`<tr><td colspan="8">${LANG.noFirewallRules}</td></tr>`);
        }
    }).fail(function() {
        $tbody.html(`<tr><td colspan="8">${LANG.errorLoadingRules}</td></tr>`);
    }).always(function() {
        $loadingIndicator.empty();
    });
}

function addFirewallRule() {
    const $submitButton = $("#addRuleButton");
    $submitButton.prop("disabled", true).html('<i class="fas fa-spinner fa-spin"></i> ' + LANG.loading);

    const ip = getSelectedIp();
    $("#destination").val(ip);

    const ruleData = {
        source: $("#source").val(),
        destination: $("#destination").val(),
        protocol: $("#protocol").val() || null,
        whitelist: ($("#actionType").val() === "whitelist"),
        comment: $("#comment").val() || LANG.noComment
    };

    const dstPort = $("#dstPort").val();
    const srcPort = $("#srcPort").val();
    if (dstPort) ruleData.dst_port = dstPort;
    if (srcPort) ruleData.src_port = srcPort;

    $.post("/modules/addons/pathnet_module/ajax.php", {
        action: "addRule",
        ip,
        ruleData
    }, function(resp) {
        if (resp.error) {
            showError(resp.error);
        } else {
            showSuccess(LANG.ruleAdded);
            fetchFirewallRules();
        }
    }).fail(function() {
        showError(LANG.ruleAddError);
    }).always(function() {
        $submitButton.prop("disabled", false).html('<i class="fas fa-plus"></i> ' + LANG.addRule);
    });
}

function deleteFirewallRule(ruleId, $button) {
    const ip = getSelectedIp();
    if (!confirm(LANG.confirmDeleteRule)) return;

    $button.prop("disabled", true).html('<i class="fas fa-spinner fa-spin"></i>');

    $.post("/modules/addons/pathnet_module/ajax.php", {
        action: "deleteRule",
        ip,
        ruleId
    }, function(resp) {
        if (resp.error) {
            showError(resp.error);
        } else {
            showSuccess(LANG.ruleDeleted);
            fetchFirewallRules();
        }
    }).fail(function() {
        showError(LANG.ruleDeleteError);
    }).always(function() {
        $button.prop("disabled", false).html('<i class="fas fa-trash-alt"></i> ' + LANG.delete);
    });
}

function fetchCurrentFilters() {
    const ip = getSelectedIp();
    const $tbody = $("#filtersTable tbody");
    const $loadingIndicator = $("#filterTableLoadingIndicator");

    $loadingIndicator.html('<i class="fas fa-spinner fa-spin"></i> ' + LANG.loading);
    $tbody.empty();

    $.post("/modules/addons/pathnet_module/ajax.php", {
        action: "getCurrentFilters",
        ip
    }, function(response) {
        let filters = [];
        try {
            filters = (typeof response === "string") ? JSON.parse(response).filters : response.filters;
        } catch (e) {
            console.error("Error parsing filters:", e);
        }

        if (filters && filters.length > 0) {
            filters.forEach(filter => {
                const addr = filter.settings.addr || "N/A";
                const port = filter.settings.port || "N/A";
                const extraSettings = Object.keys(filter.settings)
                    .filter(k => k !== "addr" && k !== "port")
                    .map(k => `${k}: ${filter.settings[k]}`)
                    .join(", ") || "N/A";
                const tr = `
    <tr>
        <td>${filter.name}</td>
        <td>${addr}</td>
        <td>${port}</td>
        <td>${extraSettings}</td>
        <td>
            <button class="btn btn-danger btn-sm delete-filter" data-filter-id="${filter.id}" data-filter-name="${filter.name}">
                <i class="fas fa-trash-alt"></i> ${LANG.delete}
            </button>
        </td>
    </tr>
    `;
                $tbody.append(tr);
            });
        } else {
            $tbody.html(`<tr><td colspan="5">${LANG.noFilters}</td></tr>`);
        }
    }).fail(function() {
        $tbody.html(`<tr><td colspan="5">${LANG.errorLoadingFilters}</td></tr>`);
    }).always(function() {
        $loadingIndicator.empty();
    });
}

function addFilter() {
    const ip = getSelectedIp();
    const $btn = $("#addFilterButton");
    $btn.prop("disabled", true).html('<i class="fas fa-spinner fa-spin"></i> ' + LANG.loading);

    const selectedFilterName = $("#filterType").val();
    if (!selectedFilterName) {
        showError(LANG.selectFilterError);
        $btn.prop("disabled", false).html('<i class="fas fa-plus"></i> ' + LANG.addFilter);
        return;
    }

    const filterData = {
        name: selectedFilterName
    };
    $("#filterFieldsContainer").find("input, select").each(function() {
        filterData[$(this).attr("name")] = $(this).val();
    });

    $.post("/modules/addons/pathnet_module/ajax.php", {
        action: "addFilter",
        ip,
        filterData
    }, function(resp) {
        if (resp.error) {
            showError(resp.error);
        } else {
            showSuccess(LANG.filterAdded);
            fetchCurrentFilters();
        }
    }).fail(function() {
        showError(LANG.filterAddError);
    }).always(function() {
        $btn.prop("disabled", false).html('<i class="fas fa-plus"></i> ' + LANG.addFilter);
    });
}

function deleteFilter(filterId, filterName, $btn) {
    const ip = getSelectedIp();
    if (!confirm(LANG.confirmDeleteFilter)) return;

    $btn.prop("disabled", true).html('<i class="fas fa-spinner fa-spin"></i>');

    $.post("/modules/addons/pathnet_module/ajax.php", {
        action: "deleteFilter",
        ip,
        filterId,
        filterName
    }, function(resp) {
        if (resp.error) {
            showError(resp.error);
        } else {
            showSuccess(LANG.filterDeleted);
            fetchCurrentFilters();
        }
    }).fail(function() {
        showError(LANG.filterDeleteError);
    }).always(function() {
        $btn.prop("disabled", false).html('<i class="fas fa-trash-alt"></i> ' + LANG.delete);
    });
}

function getFilters() {
    const ip = getSelectedIp();
    $.post("/modules/addons/pathnet_module/ajax.php", {
        action: "getFilters",
        ip
    }, function(response) {
        const jsonResponse = typeof response === "string" ? JSON.parse(response) : response;
        const filters = jsonResponse.filters || [];
        const $filterSelect = $("#filterType").empty().append('<option value="">' + LANG.selectFilterOption + '</option>');

        filters.forEach(filter => {
            $filterSelect.append(new Option(filter.label, filter.name));
        });

        $filterSelect.change(function() {
            const selectedFilter = filters.find(f => f.name === $(this).val());
            displayFilterFields(selectedFilter);
        });
    }).fail(() => showError(LANG.errorLoadingFilters));
}

function displayFilterFields(filter) {
    const $fieldsContainer = $("#filterFieldsContainer").empty();
    if (filter && filter.fields) {
        filter.fields.forEach(field => {
            let fieldHtml = `<div class="form-group"><label for="${field.name}">${field.label} ${field.example ? `(${field.example})` : ''}</label>`;
            switch (field.value.type) {
                case 'cidr':
                case 'ip':
                    fieldHtml += `<input type="text" class="form-control" id="${field.name}" name="${field.name}" value="${field.name === 'addr' ? getSelectedIp() : ''}" required>`;
                    break;
                case 'port':
                    fieldHtml += `<input type="number" class="form-control" id="${field.name}" name="${field.name}" min="1" max="65535" placeholder="Port">`;
                    break;
                case 'bool':
                    fieldHtml += `<select class="form-control" id="${field.name}" name="${field.name}"><option value="true">True</option><option value="false">False</option></select>`;
                    break;
                case 'select':
                    fieldHtml += `<select class="form-control" id="${field.name}" name="${field.name}">`;
                    field.value.options.forEach(option => {
                        fieldHtml += `<option value="${option.value}">${option.label}</option>`;
                    });
                    fieldHtml += `</select>`;
                    break;
                default:
                    fieldHtml += `<input type="text" class="form-control" id="${field.name}" name="${field.name}" placeholder="Value">`;
                    break;
            }
            fieldHtml += `</div>`;
            $fieldsContainer.append(fieldHtml);
        });
    }
}

function fetchAttackHistory() {
    const ip = getSelectedIp();
    const $tbody = $("#attackHistoryTable tbody");
    const $loading = $("#attackLoadingIndicator");

    $loading.html('<i class="fas fa-spinner fa-spin"></i> ' + LANG.loading);
    $tbody.empty();

    $.post("/modules/addons/pathnet_module/ajax.php", {
        action: "attackHistory",
        ip
    }, function(response) {
        let attacks = [];
        try {
            attacks = (typeof response === "string") ? JSON.parse(response).attack_history : response.attack_history;
        } catch (e) {
            console.error("Error parsing attack history:", e);
        }

        if (attacks && attacks.length > 0) {
            attacks.forEach(attack => {
                const start = new Date(attack.start).toLocaleString();
                let end = new Date(attack.end).toLocaleString();
                if (end === "1/1/1970, 1:00:00") {
                    end = '<span class="badge badge-danger">In progress</span>';
                }
                const peakMpkt = (attack.peak_pps.value / 1e6).toFixed(2) + " Mpkt";
                const peakGbps = ((attack.peak_bps.value * 8) / 1e9).toFixed(2) + " Gbps";
                const tr = `
    <tr>
        <td>${attack.host}</td>
        <td>${attack.reason}</td>
        <td>${start}</td>
        <td>${end}</td>
        <td>${peakMpkt}</td>
        <td>${peakGbps}</td>
    </tr>
    `;
                $tbody.append(tr);
            });
        } else {
            $tbody.html(`<tr><td colspan="6">${LANG.noAttackData}</td></tr>`);
        }
    }).fail(function() {
        $tbody.html(`<tr><td colspan="6">${LANG.errorFetchingHistory}</td></tr>`);
    }).always(function() {
        $loading.empty();
    });
}

function updateRuleDescription() {
    const selectedRule = $("#predefinedRule").val();
    const $descriptionBox = $("#ruleDescription");

    switch (selectedRule) {
        case "ssh":
            $descriptionBox.html(LANG.predefinedRuleSSHDesc).show();
            break;
        case "rdp":
            $descriptionBox.html(LANG.predefinedRuleRDPDesc).show();
            break;
        case "icmp":
            $descriptionBox.html(LANG.predefinedRuleICMPDesc).show();
            break;
        case "web":
            $descriptionBox.html(LANG.predefinedRuleWebDesc).show();
            break;
        case "vestacp":
            $descriptionBox.html(LANG.predefinedRuleVestaCPDesc).show();
            break;
        case "rust":
            $descriptionBox.html(LANG.predefinedRuleRustDesc).show();
            break;
        case "plesk":
            $descriptionBox.html(LANG.predefinedRulePleskDesc).show();
            break;
        case "minecraft":
            $descriptionBox.html(LANG.predefinedRuleMinecraftDesc).show();
            break;
        default:
            $descriptionBox.hide();
    }
}

function applyPredefinedRule() {
    const ip = getSelectedIp();
    const selectedRule = $("#predefinedRule").val();
    const $applyButton = $("#applyPredefinedRuleButton");

    if (!selectedRule) {
        showError(LANG.selectPredefinedRuleError);
        return;
    }

    $applyButton.prop("disabled", true).html('<i class="fas fa-spinner fa-spin"></i> ' + LANG.loading);

    const promises = [];

    if (selectedRule === "minecraft") {
        const ruleData = {
            source: "0.0.0.0/0",
            destination: ip,
            protocol: "tcp",
            dst_port: "25565",
            whitelist: true,
            comment: "Minecraft"
        };
        const filterData = {
            name: "mc_server",
            addr: ip,
            port: "25565"
        };

        promises.push(
            $.post("/modules/addons/pathnet_module/ajax.php", {
                action: "addRule",
                ip,
                ruleData
            })
                .done(() => {
                    fetchFirewallRules();
                    showSuccess("Minecraft rule added.");
                })
                .fail(() => showError("Error adding Minecraft rule."))
        );

        promises.push(
            $.post("/modules/addons/pathnet_module/ajax.php", {
                action: "addFilter",
                ip,
                filterData
            })
                .done(() => {
                    fetchCurrentFilters();
                    showSuccess("Minecraft filter added.");
                })
                .fail(() => showError("Error adding Minecraft filter."))
        );
    } else if (selectedRule === "plesk") {
        const pleskRules = [{
            dst_port: "143"
        }, {
            dst_port: "993"
        }, {
            dst_port: "8443"
        }, {
            dst_port: "443"
        }, {
            dst_port: "5432"
        }, {
            dst_port: "110"
        }, {
            dst_port: "25"
        }, {
            dst_port: "8880"
        }, {
            dst_port: "465"
        }, {
            dst_port: "995"
        }, {
            dst_port: "3306"
        }, {
            dst_port: "1433"
        }, {
            dst_port: "8447"
        }, {
            dst_port: "53",
            protocol: "tcp"
        }, {
            dst_port: "53",
            protocol: "udp"
        }, {
            dst_port: "443",
            protocol: "udp"
        }, {
            dst_port: "8443",
            protocol: "udp"
        }, {
            dst_port: "80",
            protocol: "tcp",
        }, {
            dst_port: "22",
            protocol: "tcp",
        }
        ];
        pleskRules.forEach(r => {
            const rData = {
                source: "0.0.0.0/0",
                destination: ip,
                protocol: r.protocol || "tcp",
                dst_port: r.dst_port,
                whitelist: true,
                comment: "Plesk"
            };
            promises.push(
                $.post("/modules/addons/pathnet_module/ajax.php", {
                    action: "addRule",
                    ip,
                    ruleData: rData
                })
                    .done(() => fetchFirewallRules())
                    .fail(() => showError("Error adding Plesk rule on port " + r.dst_port))
            );
        });
        const pleskFilters = [{
            name: "tcp_symmetric",
            addr: ip,
            port: "8443"
        },
            {
                name: "tcp_symmetric",
                addr: ip,
                port: "22"
            },
            {
                name: "tcp_symmetric",
                addr: ip,
                port: "443"
            },
            {
                name: "tcp_symmetric",
                addr: ip,
                port: "80"
            },
            {
                name: "tcp_symmetric",
                addr: ip,
                port: "21"
            },
            {
                name: "tcp_symmetric",
                addr: ip,
                port: "8880"
            }
        ];
        pleskFilters.forEach(fData => {
            promises.push(
                $.post("/modules/addons/pathnet_module/ajax.php", {
                    action: "addFilter",
                    ip,
                    filterData: fData
                })
                    .done(() => fetchCurrentFilters())
                    .fail(() => showError("Error adding Plesk filter on port " + fData.port))
            );
        });
    } else if (selectedRule === "rust") {
        const rustRule = {
            source: "0.0.0.0/0",
            destination: ip,
            protocol: "udp",
            dst_port: "28015",
            whitelist: true,
            comment: "Rust"
        };
        promises.push(
            $.post("/modules/addons/pathnet_module/ajax.php", {
                action: "addRule",
                ip,
                ruleData: rustRule
            })
                .done(() => fetchFirewallRules())
                .fail(() => showError("Error adding Rust rule."))
        );

        const rustFilters = [{
            name: "source_server",
            addr: ip,
            port: "28015",
            strict: true,
            cache: true
        },
            {
                name: "raknet_server",
                addr: ip,
                port: "28015",
                accept_queries: false
            },
            {
                name: "tcp_symmetric",
                addr: ip,
                port: "28015"
            }
        ];
        rustFilters.forEach(f => {
            promises.push(
                $.post("/modules/addons/pathnet_module/ajax.php", {
                    action: "addFilter",
                    ip,
                    filterData: f
                })
                    .done(() => fetchCurrentFilters())
                    .fail(() => showError("Error adding Rust filter on port " + f.port))
            );
        });
    } else if (selectedRule === "ssh") {
        const sshRule = {
            source: "0.0.0.0/0",
            destination: ip,
            protocol: "tcp",
            dst_port: "22",
            whitelist: true,
            comment: "SSH"
        };
        promises.push(
            $.post("/modules/addons/pathnet_module/ajax.php", {
                action: "addRule",
                ip,
                ruleData: sshRule
            })
                .done(() => fetchFirewallRules())
                .fail(() => showError("Error adding SSH rule."))
        );

        const sshFilter = {
            name: "tcp_symmetric",
            addr: ip,
            port: "22"
        };
        promises.push(
            $.post("/modules/addons/pathnet_module/ajax.php", {
                action: "addFilter",
                ip,
                filterData: sshFilter
            })
                .done(() => fetchCurrentFilters())
                .fail(() => showError("Error adding SSH filter."))
        );
    } else if (selectedRule === "rdp") {
        const rdpRule = {
            source: "0.0.0.0/0",
            destination: ip,
            protocol: "tcp",
            dst_port: "3389",
            whitelist: true,
            comment: "RDP"
        };
        promises.push(
            $.post("/modules/addons/pathnet_module/ajax.php", {
                action: "addRule",
                ip,
                ruleData: rdpRule
            })
                .done(() => fetchFirewallRules())
                .fail(() => showError("Error adding RDP rule."))
        );

        const rdpFilter = {
            name: "tcp_symmetric",
            addr: ip,
            port: "3389"
        };
        promises.push(
            $.post("/modules/addons/pathnet_module/ajax.php", {
                action: "addFilter",
                ip,
                filterData: rdpFilter
            })
                .done(() => fetchCurrentFilters())
                .fail(() => showError("Error adding RDP filter."))
        );
    } else if (selectedRule === "icmp") {
        const icmpRule = {
            source: "0.0.0.0/0",
            destination: ip,
            protocol: "icmp",
            whitelist: true,
            comment: "ICMP"
        };
        promises.push(
            $.post("/modules/addons/pathnet_module/ajax.php", {
                action: "addRule",
                ip,
                ruleData: icmpRule
            })
                .done(() => fetchFirewallRules())
                .fail(() => showError("Error adding ICMP rule."))
        );
    } else if (selectedRule === "web") {
        const webPorts = ["80", "443"];
        webPorts.forEach(port => {
            const ruleData = {
                source: "0.0.0.0/0",
                destination: ip,
                protocol: "tcp",
                dst_port: port,
                whitelist: true,
                comment: "Web"
            };
            promises.push(
                $.post("/modules/addons/pathnet_module/ajax.php", {
                    action: "addRule",
                    ip,
                    ruleData: ruleData
                })
                    .done(() => fetchFirewallRules())
                    .fail(() => showError("Error adding Web rule on port " + port))
            );
            const filterData = {
                name: "tcp_symmetric",
                addr: ip,
                port: port
            };
            promises.push(
                $.post("/modules/addons/pathnet_module/ajax.php", {
                    action: "addFilter",
                    ip,
                    filterData: filterData
                })
                    .done(() => fetchCurrentFilters())
                    .fail(() => showError("Error adding Web filter on port " + port))
            );
        });
    } else if (selectedRule === "vestacp") {
        const vestaCPPorts = [
            { port: "20", protocol: "tcp" },
            { port: "21", protocol: "tcp" },
            { port: "22", protocol: "tcp" },
            { port: "25", protocol: "tcp" },
            { port: "53", protocol: "udp" },
            { port: "80", protocol: "tcp" },
            { port: "443", protocol: "tcp" },
            { port: "110", protocol: "tcp" },
            { port: "123", protocol: "udp" },
            { port: "143", protocol: "tcp" },
            { port: "3306", protocol: "tcp" },
            { port: "5432", protocol: "tcp" },
            { port: "8080", protocol: "tcp" },
            { port: "8433", protocol: "tcp" },
            { port: "8083", protocol: "tcp" }
        ];
        vestaCPPorts.forEach(entry => {
            const ruleData = {
                source: "0.0.0.0/0",
                destination: ip,
                protocol: entry.protocol,
                dst_port: entry.port,
                whitelist: true,
                comment: "VestaCP"
            };
            promises.push(
                $.post("/modules/addons/pathnet_module/ajax.php", {
                    action: "addRule",
                    ip,
                    ruleData: ruleData
                })
                    .done(() => fetchFirewallRules())
                    .fail(() => showError("Error adding VestaCP rule on port " + entry.port))
            );
        });
    }

    $.when.apply($, promises).always(function() {
        $applyButton.prop("disabled", false).html(LANG.apply);
    });
}

function showSuccess(msg) {
    toastr.success(msg, LANG.successTitle, {
        closeButton: true,
        progressBar: true,
        timeOut: 3000,
        positionClass: "toast-top-right"
    });
}

function showError(msg) {
    toastr.error(msg, LANG.errorTitle, {
        closeButton: true,
        progressBar: true,
        timeOut: 3000,
        positionClass: "toast-top-right"
    });
}
{/literal}
</script>

