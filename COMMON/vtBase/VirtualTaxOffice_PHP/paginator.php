<?php
    $page_no = $res->page_no;
    $total_records_per_page = $res->no_of_records_per_page;
    $previous_page = $page_no - 1;
    $next_page = $page_no + 1;
    $adjacents = "2"; 

    $total_no_of_pages = $res->total_pages;
    $second_last = $total_no_of_pages - 1; 
?>
    
    <div class="pagination form-group form-inline">

    <ul class="pagination">
        <?php //if($page_no > 1){ echo "<li><a onclick='gotopage(1);'>First Page</a></li>"; } ?>
        
        <li <?php if($page_no <= 1){ echo "class='disabled'"; } ?>>
        <a <?php if($page_no > 1){ echo "onclick='gotopage(".$previous_page.");'"; } ?>>Previous</a>
        </li>
           
        <?php 
        if ($total_no_of_pages <= 10){  	 
            for ($counter = 1; $counter <= $total_no_of_pages; $counter++){
                if ($counter == $page_no) {
               echo "<li class='active'><a>".$counter."</a></li>";	
                    }else{
               echo "<li><a onclick='gotopage(".$counter.");'>".$counter."</a></li>";
                    }
            }
        }
        elseif($total_no_of_pages > 10){
            
        if($page_no <= 4) {			
         for ($counter = 1; $counter < 8; $counter++){		 
                if ($counter == $page_no) {
               echo "<li class='active'><a>".$counter."</a></li>";	
                    }else{
               echo "<li><a onclick='gotopage(".$counter.");'>".$counter."</a></li>";
                    }
            }
            echo "<li><a>...</a></li>";
            echo "<li><a onclick='gotopage(".$second_last.");'>".$second_last."</a></li>";
            echo "<li><a onclick='gotopage(".$total_no_of_pages.");'>".$total_no_of_pages."</a></li>";
            }

         elseif($page_no > 4 && $page_no < $total_no_of_pages - 4) {		 
            echo "<li><a onclick='gotopage(1);'>1</a></li>";
            echo "<li><a onclick='gotopage(2);'>2</a></li>";
            echo "<li><a>...</a></li>";
            for ($counter = $page_no - $adjacents; $counter <= $page_no + $adjacents; $counter++) {			
               if ($counter == $page_no) {
               echo "<li class='active'><a>".$counter."</a></li>";	
                    }else{
               echo "<li><a onclick='gotopage(".$counter.");'>".$counter."</a></li>";
                    }                  
           }
           echo "<li><a>...</a></li>";
           echo "<li><a onclick='gotopage(".$second_last.");'>".$second_last."</a></li>";
           echo "<li><a onclick='gotopage(".$total_no_of_pages.");'>".$total_no_of_pages."</a></li>";      
                }
            
            else {
            echo "<li><a onclick='gotopage(1);'>1</a></li>";
            echo "<li><a onclick='gotopage(2);'>2</a></li>";
            echo "<li><a>...</a></li>";

            for ($counter = $total_no_of_pages - 6; $counter <= $total_no_of_pages; $counter++) {
              if ($counter == $page_no) {
               echo "<li class='active'><a>".$counter."</a></li>";	
                    }else{
               echo "<li><a onclick='gotopage(".$counter.");'>".$counter."</a></li>";
                    }                   
                    }
                }
        }
    ?>
        
        <li <?php if($page_no >= $total_no_of_pages){ echo "class='disabled'"; } ?>>
        <a <?php if($page_no < $total_no_of_pages) { echo "onclick='gotopage(".$next_page.");'"; } ?>>Next</a>
        </li>        
        <li>&nbsp;&nbsp;</li><li><?php build_records_per_page_select($total_records_per_page, $page_no);?></li>
        </ul>        
    </div>