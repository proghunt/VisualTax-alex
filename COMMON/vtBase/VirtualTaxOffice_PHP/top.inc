<table id="holder" style="background-color: <?php echo BACKGROUND_COLOR;?>; 
                          background-image: url('<?php echo BACKGROUND_FILENAME;?>'); 
                          background-repeat: <?php echo BACKGROUND_REPEAT;?>; 
                          background-size: <?php echo BACKGROUND_SIZE;?>;">
    <tr >
        <td><canvas id="topleft_canvas" width=200px></canvas></td>
        <td>
            <div class="header">
                <div id="title_panel">
                    <table id="titles" border=0 width=100%>
                        <tr>
                            <td>
                                <center><img id="logo_header" src="img/logo_header.png"></center>
                            </td>                            
                        </tr>
                    </table>
                </div>
            </div>
        </td>
        <td><canvas id="topright_canvas" width=200px></canvas></td>
    </tr>
    <tr class="inner_body">
        <td id="left_panel_column">            
            <div id="left_panel_div" class="left_panel functions_panel" style="background-color: <?php echo LEFT_PANEL_COLOR;?>; border: <?php echo BORDER;?>; border-bottom-style: none; border-top-style: none; border-left-style: none;">                
                <div class="form-group" style="position: relative;">
                <button style="float: right;" onclick="left_collapse_expand();"><img id="left_collapse_expand_img" src="img/collapse.png"></button>
                </div><br>
                <?php include "left_menu.php"; ?>
            </div>
        </td>
        <td class="content">
            <table class="frame_table">
                <tr class="content_border_tr" style="background-color: <?php echo BORDER_COLOR;?>;">
                    <td></td>
                    <td colspan=2>                
                        <?php include "functions_menu.php"; ?>
                    </td>
                </tr>
                <tr>
                    <td class="content_border_td" style="background-color: <?php echo BORDER_COLOR;?>;"></td>
                    <td height=100%>
                        <div class="content_div" style="background-color: <?php echo PROJECTOR_COLOR;?>; border: <?php echo BORDER;?>;">
                    
                    