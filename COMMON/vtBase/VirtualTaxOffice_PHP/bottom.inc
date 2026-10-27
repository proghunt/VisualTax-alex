                        </div>
                    </td>
                    <td class="content_border_td" style="background-color: <?php echo BORDER_COLOR;?>;"></td>
                </tr>
                <tr class="content_border_tr" style="background-color: <?php echo BORDER_COLOR;?>;">
                    <td colspan=3></td>
                </tr>
            </table>
            </div>
        </td>
        <td id="right_panel_column">
            <div id="right_panel_div" class="right_panel functions_panel" style="background-color: <?php echo RIGHT_PANEL_COLOR;?>; border: <?php echo BORDER;?>; border-bottom-style: none; border-top-style: none; border-right-style: none;">
                <div class="form-group" style="position: relative;">
                <button style="float: left;" onclick="right_collapse_expand();"><img id="right_collapse_expand_img" src="img/collapse.png"></button>
                </div><br>
                <?php include "right_menu.php"; ?>
            </div>
        </td>
    </tr>
    <tr class="floor">
        <td colspan=3 ><canvas id="floor_canvas"></canvas></td>
    </tr>
</table>

<!--<div id="left_wall" class="left_wall_div">
    <div class="left_wall_panel" style="background-color: silver; padding:10px;">
        <div class="form-group" style="position: relative;">
        <button style="float: right;" onclick="left_collapse_expand();"><img id="left_collapse_expand_img" src="img/collapse.png"></button>
        </div><br>
        <?php include "left_menu.php"; ?>
    </div>
</div>
-->

<script>
    if (localStorage.getItem("left_panel_visible") == "false") {
        left_collapse_expand();
    }
    if (localStorage.getItem("right_panel_visible") == "false") {
        right_collapse_expand();
    }
</script>