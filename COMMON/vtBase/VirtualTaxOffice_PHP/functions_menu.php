<?php 
// Initialize the session
if (session_id() == ''){
    session_start();
}

require_once "apicontroller.php";
$current_file = basename($_SERVER["SCRIPT_FILENAME"], '.php');

if (isset($_SESSION["adminloggedin"]) && $_SESSION["adminloggedin"] == true ) {   
    ?>
    <?php if ($current_file == "admin_show_taxoffices") { ?>
        <div class="btn btn-warning btn-sm">Virtual Offices</div>
    <?php } else { ?>
        <button type="button" class="btn btn-primary btn-sm" onclick="location.href='admin_show_taxoffices.php';">Virtual Offices</button>
    <?php }?>
    <?php if ($current_file == "admin_show_taxpayers") { ?>
        <div class="btn btn-warning btn-sm">Virtual Clients</div>
    <?php } else { ?>
        <button type="button" class="btn btn-primary btn-sm" onclick="location.href='admin_show_taxpayers.php';">Virtual Clients</button>
    <?php }?>
    <?php if ($current_file == "admin_show_efilers") { ?>
        <div class="btn btn-warning btn-sm">Efilers</div>
    <?php } else { ?>
        <button type="button" class="btn btn-primary btn-sm" onclick="location.href='admin_show_efilers.php';">Efilers</button>
    <?php } ?>
    <button type="button" class="btn btn-primary btn-sm" onclick="location.href='logout.php';">Logout</button> 
<?php
}
elseif(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true) {
    ?>
    <button type="button" class="btn btn-primary" onclick="location.href='login.php';">Login</button>
    <?php
} else {    
    $current_cyberid = $_SESSION["cyberid"];
    if ($_SESSION["payer"]) {                
        $query = 
            "SELECT *, (SELECT COUNT(*) 
                        FROM TaxFormHeaders
                            INNER JOIN TaxFormProposals ON TaxFormHeaders.Id = TaxFormProposals.TaxFormHeaderId
                        WHERE TaxFormHeaders.TaxFormId = 1 AND TaxFormHeaders.TaxPayerCyberId = TaxPayers.CyberId
                          AND TaxFormProposals.OfficeStatus = 'S' AND TaxFormProposals.PayerStatus = 'N'
                        ) AS ProposalCount
             FROM TaxPayers 
             WHERE UPPER(CyberId) = UPPER(:CyberId)";
        $stmt = $taxpayers_db->prepare($query);
        $stmt->bindParam(':CyberId', $current_cyberid);                    
        $stmt->execute();
        $result = $stmt->fetch(); 
        if ($result) {
            $_SESSION["T1RequestsProposalCount"] = $result["ProposalCount"];
        }      
        
        if ($current_file == "taxpayer") { ?>
            <div class="btn btn-warning btn-sm">Virtual Client Profile</div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary btn-sm" onclick="location.href='taxpayer.php';">Virtual Client Profile</button>
        <?php }?>
        <?php if ($current_file == "T1ServiceRequest") { ?>
            <div class="btn btn-warning btn-sm">T1 Service Request
                <?php if ($_SESSION["T1RequestsProposalCount"] > 0) { ?><span class="badge badge-light"><?php echo $_SESSION["T1RequestsProposalCount"]?></span> <?php }?>
            </div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary btn-sm" onclick="location.href='T1ServiceRequest.php';">T1 Service Request 
                <?php if ($_SESSION["T1RequestsProposalCount"] > 0) { ?><span class="badge badge-light"><?php echo $_SESSION["T1RequestsProposalCount"]?></span> <?php }?>
            </button>
        <?php } 
    } 
    elseif ($_SESSION["office"]) {
        if ($current_file == "taxoffice") { ?>
            <div class="btn btn-warning btn-sm">Virtual Office Profile</div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary btn-sm" onclick="location.href='taxoffice.php';" >Virtual Office Profile</button>
        <?php }?>
        <?php if ($current_file == "T1ServiceRequest_list") { ?>
            <div class="btn btn-warning btn-sm">T1 Service Requests</div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary btn-sm" onclick="location.href='T1ServiceRequest_list.php';" >T1 Service Requests</button>
        <?php }    
        if ($current_file == "taxoffice_clients_list") { ?>
            <div class="btn btn-warning btn-sm">Virtual Clients</div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary btn-sm" onclick="location.href='taxoffice_clients_list.php';" >Virtual Clients</button>
        <?php }         
    }     
    ?>
    <button type="button" class="btn btn-primary btn-sm" onclick="location.href='logout.php';" >Logout</button>     
    <?php
     
}
?>
