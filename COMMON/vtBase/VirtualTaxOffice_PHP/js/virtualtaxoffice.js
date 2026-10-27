function url_redirect(url){
    var X = setTimeout(function(){
        window.location.replace(url);
        return true;
    },300);

    if( window.location = url ){
        clearTimeout(X);
        return true;
    } else {
        if( window.location.href = url ){
            clearTimeout(X);
            return true;
        }else{
            clearTimeout(X);
            window.location.replace(url);
            return true;
        }
    }
    return false;
}; 

function showPopup(url) {        
    need_refresh = false;
    document.getElementById('editFrame').src = "";
    document.getElementById('modaldlg').style.width = "90%";
    //document.getElementById('modaldlg').style.height = window.innerHeight + "px";
    document.getElementById('editFrame').style.width = "100%"; 
    document.getElementById('editFrame').style.height = window.innerHeight - 150 + "px"; 
    document.getElementById('editFrame').src=url;                  
}; 

function getDocumentHeight() {
    doc = document;
    return Math.max(
            doc.body.scrollHeight, doc.documentElement.scrollHeight,
            doc.body.offsetHeight, doc.documentElement.offsetHeight,
            doc.body.clientHeight, doc.documentElement.clientHeight
        );   
}

function statusCheck(id) {
    cb = document.getElementById('cb' + id);
    if (cb) {
        const formData = new FormData();
        formData.append('action', 'SAVE_PROFILE');
        formData.append('CyberId', id);
        if (cb.checked) {
            formData.append('Status', 'A');    
        }
        else {
            formData.append('Status', 'I');
        }

        var request = new XMLHttpRequest();
        request.open('POST', 'api.php', false);
        try {
            request.send(formData);
            result = JSON.parse(request.response);
            if (result.success!="true") {                    
                alert(result.error_message);
            }
        }
        catch (error) {
            alert(error + '\n\n' + request.response);
        }            
    }
}; 

function tableLoad() {
    l = document.getElementById('loading');
    t = document.getElementById('offices');
    if (l) {
        l.style.visibility = "hidden";
    }
    if (t) {
        t.style.visibility = "visible";    
    }
};

function updateBottomCorner() {
    var holderTable = document.getElementById('holder');
    if (holderTable) {
        var bottomCells = holderTable.rows.item(2).cells;
        bc = document.getElementById('bottom_left_corner');
        if (bc) {
            w = bottomCells.item(0).offsetWidth;
            h = bottomCells.item(0).offsetHeight;
            bc.style.cssText = 'border-top: 100px solid #f5f5f5; border-right: '+ w +'px solid transparent;';
        }
        bc = document.getElementById('bottom_right_corner');
        if (bc) {
            w = bottomCells.item(2).offsetWidth;
            h = bottomCells.item(2).offsetHeight;
            //bc.style.cssText = 'border-top: '+ h +'px solid #f5f5f5; border-left: '+ w +'px solid transparent;';
            bc.style.cssText = 'border-top: 100px solid #f5f5f5; border-left: '+ w +'px solid transparent;';
        }
    }
}

function draw_header(left_width, right_width) {
    var holderTable = document.getElementById('holder');
    if (holderTable) {
        var topleft_canvas = document.getElementById('topleft_canvas');
        var topright_canvas = document.getElementById('topright_canvas');
        topleft_canvas.width = 0;
        total_height = 100;
        
        var contentCells = holderTable.rows.item(0).cells;
        
        topleft_canvas.width = left_width;
        topright_canvas.width = right_width;
        topleft_canvas.height = total_height;
        topright_canvas.height = total_height;
        total_width = total_width;
        
        if (topleft_canvas.getContext && topright_canvas.getContext) {
            var ctx_left = topleft_canvas.getContext('2d');
            var ctx_right = topright_canvas.getContext('2d');
            
            // clear corners
            ctx_left.fillStyle = LEFT_PANEL_COLOR;
            ctx_left.beginPath();            
            ctx_left.moveTo(0, 0);
            ctx_left.lineTo(0, total_height);
            ctx_left.lineTo(left_width, total_height);
            ctx_left.lineTo(0, 0);
            ctx_left.fill();            
            ctx_left.closePath();
            
            ctx_right.fillStyle = RIGHT_PANEL_COLOR;
            ctx_right.beginPath();            
            ctx_right.lineTo(right_width, 0);
            ctx_right.lineTo(right_width, total_height);
            ctx_right.lineTo(0, total_height);
            ctx_right.lineTo(right_width, 0);
            ctx_right.fill();
            ctx_right.closePath();
            
            if (BORDER_WIDTH > 0) {
                ctx_left.strokeStyle = BORDER_COLOR;
                ctx_left.lineWidth = BORDER_WIDTH;
                ctx_left.beginPath(); 
                ctx_left.moveTo(BORDER_WIDTH / 2, 0);
                ctx_left.lineTo(left_width, total_height);
                ctx_left.stroke();
                ctx_left.closePath();
                
                ctx_right.strokeStyle = BORDER_COLOR;
                ctx_right.lineWidth = BORDER_WIDTH;
                ctx_right.beginPath(); 
                ctx_right.moveTo(right_width - BORDER_WIDTH / 2, 0);
                ctx_right.lineTo(0, total_height);
                ctx_right.stroke();
                ctx_right.closePath();
            }
            
            /*ctx.font = '48px serif';
            ctx.strokeText(
                total_width + ' - ' + 
                contentCells.item(1).offsetWidth + ' - ' +
                w1 + ' - ' + w2
                , 10, 50);*/
        }
        else {
            alert('Not supported');
        }
    }   
}  

function roundRect(ctx, x, y, width, height, radius, fill, stroke) {
  if (typeof stroke === 'undefined') {
    stroke = true;
  }
  if (typeof radius === 'undefined') {
    radius = 5;
  }
  if (typeof radius === 'number') {
    radius = {tl: radius, tr: radius, br: radius, bl: radius};
  } else {
    var defaultRadius = {tl: 0, tr: 0, br: 0, bl: 0};
    for (var side in defaultRadius) {
      radius[side] = radius[side] || defaultRadius[side];
    }
  }
  ctx.beginPath();
  ctx.moveTo(x + radius.tl, y);
  ctx.lineTo(x + width - radius.tr, y);
  ctx.quadraticCurveTo(x + width, y, x + width, y + radius.tr);
  ctx.lineTo(x + width, y + height - radius.br);
  ctx.quadraticCurveTo(x + width, y + height, x + width - radius.br, y + height);
  ctx.lineTo(x + radius.bl, y + height);
  ctx.quadraticCurveTo(x, y + height, x, y + height - radius.bl);
  ctx.lineTo(x, y + radius.tl);
  ctx.quadraticCurveTo(x, y, x + radius.tl, y);
  ctx.closePath();
  if (fill) {
    ctx.fill();
  }
  if (stroke) {
    ctx.stroke();
  }
}  

function draw_floor() {
    var holderTable = document.getElementById('holder');
    if (holderTable) {
        var canvas = document.getElementById('floor_canvas');
        canvas.width = 0;
        total_height = 100;
        
        var contentCells = holderTable.rows.item(1).cells;
        
        var counter = 0;
        while (true) {
            total_width = contentCells.item(0).offsetWidth + contentCells.item(1).offsetWidth + contentCells.item(2).offsetWidth;
            left_width = contentCells.item(0).offsetWidth;            
            right_width = total_width - contentCells.item(0).offsetWidth - contentCells.item(1).offsetWidth;
            canvas.width = total_width;
            if (total_width == contentCells.item(0).offsetWidth + contentCells.item(1).offsetWidth + contentCells.item(2).offsetWidth || counter > 10) {
                break;
            }
            counter++;
        };
        canvas.height = total_height;
        total_width = total_width;
        
        if (canvas.getContext) {
            var ctx = canvas.getContext('2d');
            
            
            ctx.fillStyle = FLOOR_COLOR;
            ctx.strokeStyle = GROUT_COLOR;
            
            ctx.beginPath();
            
            for (var i=1; i<=4; i++) {
                ctx.moveTo(0, 100/4*i);
                ctx.lineTo(total_width, 100/4*i);
            }
            
            ctx.moveTo(left_width, 0);
            ctx.lineTo(total_width - right_width, 0);
            ctx.lineTo(total_width, total_height);
            ctx.lineTo(0, total_height);
            ctx.lineTo(left_width, 0);
            ctx.fill();
            
            for (var i=0; i<=10; i++) {
                ctx.moveTo(left_width + ((total_width - left_width - right_width) / 10) * i, 1);
                ctx.lineTo((total_width / 10) * i, total_height);
            }
            ctx.stroke();
            ctx.closePath();
            
            // clear corners
            ctx.fillStyle = LEFT_PANEL_COLOR;
            ctx.beginPath();            
            ctx.moveTo(0, 0);
            ctx.lineTo(left_width, 0);
            ctx.lineTo(0, total_height);
            ctx.lineTo(0, 0);
            ctx.fill();
            ctx.closePath();
            
            ctx.fillStyle = RIGHT_PANEL_COLOR;
            ctx.beginPath();            
            ctx.moveTo(total_width - right_width, 0);
            ctx.lineTo(total_width, 0);
            ctx.lineTo(total_width, total_height);
            ctx.lineTo(total_width - right_width, 0);
            ctx.fill();
            ctx.closePath();
            
            /*
            if (BORDER_WIDTH > 0) {
                ctx.strokeStyle = BORDER_COLOR;
                ctx.lineWidth = BORDER_WIDTH;
                ctx.beginPath(); 
                ctx.moveTo(BORDER_WIDTH / 2, 0);
                ctx.lineTo(BORDER_WIDTH / 2, total_height);
                ctx.stroke();
                ctx.closePath();
                
                ctx.beginPath(); 
                ctx.moveTo(total_width - BORDER_WIDTH / 2, 0);
                ctx.lineTo(total_width - BORDER_WIDTH / 2, total_height);
                ctx.stroke();
                ctx.closePath();
            }
            */
            
            // draw monitor stand
            ctx.fillStyle = BORDER_COLOR;
            ctx.fillRect((total_width / 2) - 10, 0, 20, 20);
            roundRect(ctx, (total_width / 2) - 100, 20, 200, 20, 5, 'gray');
            /*ctx.font = '48px serif';
            ctx.strokeText(
                total_width + ' - ' + 
                contentCells.item(1).offsetWidth + ' - ' +
                w1 + ' - ' + w2
                , 10, 50);*/
                
            draw_header(left_width, right_width);
        }
        else {
            alert('Not supported');
        }
    }    
}

function left_collapse_expand() {
    var panel = document.getElementById('left_menu_panel');
    var img = document.getElementById('left_collapse_expand_img');
    var column = document.getElementById('left_panel_column');
    var d = document.getElementById('left_panel_div');
    var topleft_canvas = document.getElementById('topleft_canvas');
    if (panel) {
        if (panel.style.visibility == "hidden") {
            panel.style.visibility = "visible";  
            panel.style.position = "relative";
            if (img) {
                img.src = "img/collapse.png";
            }
            if (column) {
                column.style.width = "200px";
            }
            if (d) {
                d.style.padding = "19px";
            }
            if (topleft_canvas) {
                topleft_canvas.width = "0px";
            }
            localStorage.setItem("left_panel_visible", "true");
        }
        else {
            panel.style.visibility = "hidden";  
            panel.style.position = "absolute";            
            if (img) {
                img.src = "img/expand.png";
            }  
            if (column) {
                column.style.width = "30px";
            } 
            if (d) {
                d.style.padding = "5px";
            }  
            if (topleft_canvas) {
                topleft_canvas.width = "0px";
            }
            localStorage.setItem("left_panel_visible", "false");            
        }
    }
    draw_floor();
}

function right_collapse_expand() {
    var panel = document.getElementById('right_menu_panel');
    var img = document.getElementById('right_collapse_expand_img');
    var column = document.getElementById('right_panel_column');
    var panel = document.getElementById('right_menu_panel');
    var d = document.getElementById('right_panel_div');
    var topright_canvas = document.getElementById('topright_canvas');
    if (panel) {
        if (panel.style.visibility == "hidden") {
            panel.style.visibility = "visible";  
            panel.style.position = "relative";
            if (img) {
                img.src = "img/collapse.png";
            }
            if (column) {
                column.style.width = "200px";
            }
            if (d) {
                d.style.padding = "19px";
            }
            if (topright_canvas) {
                topright_canvas.width = "0px";
            }
            localStorage.setItem("right_panel_visible", "true");
        }
        else {
            panel.style.visibility = "hidden"; 
            panel.style.position = "absolute";  
            panel.style.left = "0px";            
            if (img) {
                img.src = "img/expand.png";
            }  
            if (column) {
                column.style.width = "30px";
            } 
            if (d) {
                d.style.padding = "5px";
            } 
            if (topright_canvas) {
                topright_canvas.width = "0px";
            }
            localStorage.setItem("right_panel_visible", "false");            
        }
    }
    draw_floor();
}

function adjust_titles() {
    
    var titlesTable = document.getElementById('titles');
    var logo_message = document.getElementById('logo_message');
    var company_name = document.getElementById('company_name');
    if (titlesTable) {
        var contentCells = titlesTable.rows.item(0).cells;
        
        if (company_name) {
            company_name.style.visibility = "hidden";
            company_name.style.width = 0;
        }
        if (logo_message) {
            logo_message.style.visibility = "hidden";
            logo_message.style.width = 0;
        }
        
        
        if (company_name) {
            company_name.style.width = (contentCells.item(1).offsetWidth - 20) + "px";            
        }
        if (logo_message) {
            logo_message.style.width = (contentCells.item(1).offsetWidth - 20) + "px";            
        }       
        
        
        if (company_name) {
            company_name.style.visibility = "visible";
        }
        if (logo_message) {
            logo_message.style.visibility = "visible";
        }
    }
}

function adjust_walls() {
    var angle = 12.5*Math.PI/180;
    var height = getDocumentHeight();
    var top_height = 100;
    var left_width = 200;
    var left_wall = document.getElementById('left_wall');
    if (left_wall) {        
        left_wall.style.height = height + "px";   
    }
    var p = top_height * (Math.sin(angle) * left_width) / (Math.cos(angle) * left_width - top_height);
    
    // initial coordinates
    var A = 0;
    var B = height;
    // translate the center (assuming -perspective-origin at 50%)
    A -= height/2;
    B -= height/2;
    
    p = top_height * (Math.sin(angle) * left_width) / (Math.cos(angle) * left_width - top_height);
    
}

function main_load_resize() {        
    draw_floor();
    adjust_titles();
    //adjust_walls(); not finished
}

window.addEventListener('load', main_load_resize);
window.addEventListener('resize', main_load_resize);