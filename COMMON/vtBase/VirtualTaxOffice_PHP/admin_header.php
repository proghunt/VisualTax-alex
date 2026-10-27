    
<div>
    <h2>Admin panel</h2>
</div>
<div width=100%>
  <div class="row">
    <div class="col-md-10">
        <?php if ($curr_admin_page == "admin_show_taxoffices") { ?>
            <div class="btn btn-warning">Tax Offices</div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary" onclick="location.href='admin_show_taxoffices.php';">Tax Offices</button>
        <?php }?>
        <?php if ($curr_admin_page == "admin_show_taxpayers") { ?>
            <div class="btn btn-warning">Tax Payers</div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary" onclick="location.href='admin_show_taxpayers.php';">Tax Payers</button>
        <?php }?>
        <?php if ($curr_admin_page == "admin_show_efilers") { ?>
            <div class="btn btn-warning">Efilers</div>
        <?php } else { ?>
            <button type="button" class="btn btn-primary" onclick="location.href='admin_show_efilers.php';">Efilers</button>
        <?php }?>
    </div>
    <div class="col-md-2">
        <span class="pull-right">
        <button type="button" class="btn btn-primary" onclick="location.href='logout.php';">Logout</button> 
        </span>
    </div>
  </div>
</div>
