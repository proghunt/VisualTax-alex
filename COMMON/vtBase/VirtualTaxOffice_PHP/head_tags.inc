<?php 

require_once "config.php"; 
init_color_settings(); 

?>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="css/virtualtaxoffice.css?v=<?php echo VERSION?>">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  <script src="js/virtualtaxoffice.js?v=<?php echo VERSION?>"></script> 
  <script>  
    const LEFT_PANEL_COLOR = '<?php echo LEFT_PANEL_COLOR;?>';
    const RIGHT_PANEL_COLOR = '<?php echo RIGHT_PANEL_COLOR;?>';
    const FLOOR_COLOR = '<?php echo FLOOR_COLOR;?>';
    const GROUT_COLOR = '<?php echo GROUT_COLOR;?>';
    const BORDER_COLOR = '<?php echo BORDER_COLOR;?>';
    const BORDER_WIDTH = <?php echo BORDER_WIDTH;?>;
  </script>
  <style>
    .company_text {
        color: <?php echo COMPANY_NAME_COLOR;?>;
        font-size: <?php echo COMPANY_NAME_SIZE;?>px;
    }
    .logo_text {
        color: <?php echo LOGO_MESSAGE_COLOR;?>;
        font-size: <?php echo LOGO_MESSAGE_SIZE;?>px;
    }
    .name_text {
        color: <?php echo NAME_COLOR;?>;
        font-size: <?php echo NAME_SIZE;?>px;
    }
    .other_text {
        color: <?php echo OTHER_TEXT_COLOR;?>;
        font-size: <?php echo OTHER_TEXT_SIZE;?>px;
    }
  </style>