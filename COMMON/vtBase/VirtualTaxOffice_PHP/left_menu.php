<div id="left_menu_panel" class="btn-group-vertical center-block">
<?php 
// Initialize the session
if (session_id() == ''){
    session_start();
}

require_once "apicontroller.php";
$current_file = basename($_SERVER["SCRIPT_FILENAME"], '.php');

if(isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] == true) {       
    $current_cyberid = $_SESSION["cyberid"];    
    
    $taxoffice_cyberid = "";
    
    if ($_SESSION["office"]) {
        $taxoffice_cyberid = $current_cyberid;
    }
    elseif ($_SESSION["payer"]) {  
        $query = 
            "SELECT TaxOfficeCyberId
             FROM TaxPayers 
             WHERE UPPER(CyberId) = UPPER(:CyberId)";
        $stmt = $taxpayers_db->prepare($query);
        $stmt->bindParam(':CyberId', $current_cyberid);                    
        $stmt->execute();
        $result = $stmt->fetch(); 
        $taxoffice_cyberid = $result["TaxOfficeCyberId"];
    }
    
    if (!is_empty($taxoffice_cyberid)) {
        $query = 
            "SELECT TaxOffices.*, ColorSettings.LogoFileName, ColorSettings.LogoMessage, DATEDIFF(ExpireDate, CURRENT_DATE) AS ExpireDays 
             FROM TaxOffices 
                LEFT JOIN ColorSettings ON UPPER(ColorSettings.TaxOfficeCyberId) = UPPER(TaxOffices.CyberId)                
             WHERE UPPER(TaxOffices.CyberId) = UPPER(:CyberId)";
        $stmt = $taxoffices_db->prepare($query);
        $stmt->bindParam(':CyberId', $taxoffice_cyberid);                    
        $stmt->execute();
        $result = $stmt->fetch(); 
        if ($result) {
            if ($_SESSION["office"] && $result["ExpireDays"] <= 10) {
               ?><div class="form-group text-center wordwrap" style="background-color: #f0ad4e; color: white;"><br><strong>Your account will be expired in <?php echo $result["ExpireDays"] . " " . ($result["ExpireDays"] > 1 ? "days" : "day"); ?></strong><br>&nbsp;</div>
            <?php } ?>
            
            <div class="form-group wordwrap company_text"><strong><?php echo $result["BusinessName"] ?></strong></div>
            <?php 
            if (!is_empty($result["LogoFileName"])) {?>
                <div class="form-group"><img id="office_logo" src="<?php echo $result["LogoFileName"];?>"></div>
            <?php } 
            if (!is_empty($result["LogoMessage"])) {?>
                <div class="form-group logo_text"><?php echo $result["LogoMessage"]?></div>
            <?php } ?>
            <div class="form-group wordwrap other_text">Virtual ID: <?php echo $result["CyberId"]?></div>
            <div class="form-group wordwrap other_text"><?php echo $result["Area"] . " " . $result["Phone"]?></div>
            <?php 
            if (!is_empty($result["WebSiteUrl"])) {?>
                <div class="form-group wordwrap other_text"><a href="<?php echo $result["WebSiteUrl"]?>"><?php echo $result["WebSiteUrl"]?></a></div>
            <?php } ?> 
            <div class="form-group wordwrap other_text" style="width: 100%"><a href="mailto:<?php echo $result["Email"]?>"><?php echo $result["Email"]?></a></div>
            <?php
        }
    }
    
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
            if (!is_empty($taxoffice_cyberid)) {
                ?>
                <hr style="border: <?php echo BORDER;?>;">
                <div class="form-group wordwrap other_text">Proudly serving</div>
                <?php
            }            
            ?>
            <div class="form-group wordwrap name_text"><strong><?php echo $result["FirstName"] . " " . $result["LastName"]?></strong></div>
            <div class="form-group wordwrap other_text"><?php echo $result["Area"] . " " . $result["Phone"]?></div>
            <div class="form-group wordwrap other_text">Virtual ID: <?php echo $result["CyberId"]?></div>
            <div class="form-group wordwrap other_text"><a href="mailto:<?php echo $result["Email"]?>"><?php echo $result["Email"]?></a></div>
            <?php
            if (!is_empty($result["PhotoFile"])) {?>
                <div class="form-group"><img id="payer_photo" src="<?php echo $result["PhotoFile"];?>"></div>
            <?php } 
        }
    }
    else {        
        $_SESSION["T1RequestsProposalCount"] = 0;
    }       
}
?>
</div>