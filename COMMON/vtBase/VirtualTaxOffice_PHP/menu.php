<div class="btn-group-vertical center-block">
<?php 
// Initialize the session
if (session_id() == ''){
    session_start();
}

require_once "apicontroller.php";
$current_file = basename($_SERVER["SCRIPT_FILENAME"], '.php');

if (isset($_SESSION["adminloggedin"]) && $_SESSION["adminloggedin"] == true ) {   
    ?>
    <div class="form-group"><strong>Admin panel</strong></div>
    <?php if ($current_file == "admin_show_taxoffices") { ?>
        <div class="btn btn-warning">Virtual Offices</div>
    <?php } else { ?>
        <button type="button" class="btn btn-primary" onclick="location.href='admin_show_taxoffices.php';">Virtual Offices</button>
    <?php }?>
    <?php if ($current_file == "admin_show_taxpayers") { ?>
        <div class="btn btn-warning">Virtual Clients</div>
    <?php } else { ?>
        <button type="button" class="btn btn-primary" onclick="location.href='admin_show_taxpayers.php';">Virtual Clients</button>
    <?php }?>
    <?php if ($current_file == "admin_show_efilers") { ?>
        <div class="btn btn-warning">Efilers</div>
    <?php } else { ?>
        <button type="button" class="btn btn-primary" onclick="location.href='admin_show_efilers.php';">Efilers</button>
    <?php } ?>
    <button type="button" class="btn btn-primary" onclick="location.href='logout.php';">Logout</button> 
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
             WHERE CyberId = :CyberId";
        $stmt = $taxpayers_db->prepare($query);
        $stmt->bindParam(':CyberId', $current_cyberid);                    
        $stmt->execute();
        $result = $stmt->fetch(); 
        if ($result) {
            $_SESSION["T1RequestsProposalCount"] = $result["ProposalCount"];
            ?>
            <div class="form-group"><strong><?php echo $result["FirstName"] . " " . $result["LastName"]?></strong></div>
            <div class="form-group"><?php echo $result["Area"] . " " . $result["Phone"]?></div>
            <div class="form-group">Virtual ID: <?php echo $result["CyberId"]?></div>
            <div class="form-group"><a href="mailto:<?php echo $result["Email"]?>"><?php echo $result["Email"]?></a></div>
            <?php
        }
    
        if ($current_file == "taxpayer") { ?>
            <div class="btn btn-warning">Virtual Client Profile</div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary" onclick="location.href='taxpayer.php';">Virtual Client Profile</button>
        <?php }?>
        <?php if ($current_file == "T1ServiceRequest") { ?>
            <div class="btn btn-warning">T1 Service Request
                <?php if ($_SESSION["T1RequestsProposalCount"] > 0) { ?><span class="badge badge-light"><?php echo $_SESSION["T1RequestsProposalCount"]?></span> <?php }?>
            </div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary" onclick="location.href='T1ServiceRequest.php';">T1 Service Request 
                <?php if ($_SESSION["T1RequestsProposalCount"] > 0) { ?><span class="badge badge-light"><?php echo $_SESSION["T1RequestsProposalCount"]?></span> <?php }?>
            </button>
        <?php }
    }
    elseif ($_SESSION["office"]) {
        $query = "SELECT * FROM TaxOffices WHERE CyberId = :CyberId";
        $stmt = $taxoffices_db->prepare($query);
        $stmt->bindParam(':CyberId', $current_cyberid);                    
        $stmt->execute();
        $result = $stmt->fetch(); 
        if ($result) {
            ?>
            <div class="form-group"><strong><?php echo $result["BusinessName"] ?></strong></div>
            <div class="form-group"><?php echo $result["Area"] . " " . $result["Phone"]?></div>
            <div class="form-group">Virtual ID: <?php echo $result["CyberId"]?></div>
            <div class="form-group" style="width: 100%"><a href="mailto:<?php echo $result["Email"]?>"><?php echo $result["Email"]?></a></div>
            <?php
        }
        
        if ($current_file == "taxoffice") { ?>
            <div class="btn btn-warning">Virtual Office Profile</div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary" onclick="location.href='taxoffice.php';">Virtual Office Profile</button>
        <?php }?>
        <?php if ($current_file == "T1ServiceRequest_list") { ?>
            <div class="btn btn-warning">T1 Service Requests</div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary" onclick="location.href='T1ServiceRequest_list.php';">T1 Service Requests</button>
        <?php }
    }    
    ?> 
    <button type="button" class="btn btn-primary" onclick="location.href='logout.php';">Logout</button>     
    <?php
}
?>

</div>