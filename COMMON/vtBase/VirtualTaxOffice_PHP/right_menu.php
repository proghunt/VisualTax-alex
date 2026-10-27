<div id="right_menu_panel" class="btn-group-vertical center-block">
<?php 
// Initialize the session
if (session_id() == ''){
    session_start();
}

require_once "apicontroller.php";
$current_file = basename($_SERVER["SCRIPT_FILENAME"], '.php');

if(isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] == true) {        
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
        $query = "SELECT * FROM TaxOffices WHERE UPPER(CyberId) = UPPER(:CyberId)";
        $stmt = $taxoffices_db->prepare($query);
        $stmt->bindParam(':CyberId', $taxoffice_cyberid);                    
        $stmt->execute();
        $result = $stmt->fetch(); 
        if ($result) {
            ?> 
            <div class="form-group wordwrap other_text"><strong>Services provided:</strong></div>
            <?php if ($result["T1"] == "Y") { ?>
                <div class="form-group wordwrap other_text">T1</div>
            <?php } ?>
            <?php if ($result["T2"] == "Y") { ?>
                <div class="form-group wordwrap other_text">T2</div>
            <?php } ?>
            <?php if ($result["T3"] == "Y") { ?>
                <div class="form-group wordwrap other_text">T3</div>
            <?php } ?>
            <?php if ($result["T4T5"] == "Y") { ?>
                <div class="form-group wordwrap other_text">T4T5</div>
            <?php } ?>
            <?php if ($result["NR4"] == "Y") { ?>
                <div class="form-group wordwrap other_text">NR4</div>
            <?php } ?>
            <?php if ($result["T3010"] == "Y") { ?>
                <div class="form-group wordwrap other_text">T3010</div>
            <?php } ?>
            <?php if ($result["T5013"] == "Y") { ?>
                <div class="form-group wordwrap other_text">T5013</div>
            <?php } ?>
            <?php if ($result["T5018"] == "Y") { ?>
                <div class="form-group wordwrap other_text">T5018</div>
            <?php } ?>
            <?php if ($result["vtNOA"] == "Y") { ?>
                <div class="form-group wordwrap other_text">vtNOA</div>
            <?php } ?>
            <?php if (!is_empty($result["OtherServiceDescription"])) { ?>
                <div class="form-group wordwrap other_text"><?php echo $result["OtherServiceDescription"] ?></div>
            <?php } ?>
            <?php if (!is_empty($result["Experience"])) { ?>
                <div class="form-group wordwrap other_text"><?php echo $result["Experience"] ?></div>
            <?php } 
        }        
    }     
}
?>
</div>