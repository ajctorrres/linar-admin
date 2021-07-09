const express = require("express");
const mysql = require("mysql");
const bodyParser = require("body-parser");
const bcrypt = require("bcrypt");
const saltRounds = 10;
const session = require("express-session");
const urlencodedParser = bodyParser.urlencoded({extended: true});
const moment = require('moment');
const { response } = require("express");
const app = express();
app.set("view engine", "ejs");

app.use(express.static("./public"));
app.use('/css', express.static(__dirname + 'public/css'));
app.use('/js', express.static(__dirname + 'public/js'));
app.use('/img', express.static(__dirname + 'public/img'));
app.use('/assets', express.static(__dirname + 'public/assets'));

const connection =  mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "linarf",
    dateStrings: true,
    multipleStatements: true
});

connection.connect((err)=>{
    if (err) throw err;
    console.log("Database connected");
})

function generateUUID(){
    let generate = "";
    const char = '0123456789';
    const length = 10;
    for ( var i = 0; i < length; i++ ) {
        generate += char.charAt(Math.floor(Math.random() * char.length));
    }
    checkExists(generate);
    return generate;
}

function checkExists(code){
    connection.query("SELECT * FROM agent WHERE id = '"+code+"'", (err, response) => {
        if (err) throw err;
        if (response.length > 0){
            return code;
        }else{
            generateUUID();
        }
    })
}


app.use(session({
    secret: "P@$$vv0rd",
    saveUninitialized: true,
    resave: true,
    rolling: true, // <-- Set `rolling` to `true`
    cookie: {
    httpOnly: true,
    maxAge: 1*60*60*1000
  }
}));



var now = moment();
var jsonNow = now.toJSON();

app.post('/register', urlencodedParser, (req, res)=>{
    let salt = bcrypt.genSaltSync(saltRounds);
    let hash = bcrypt.hashSync(req.body.userpassword, salt);
    connection.query('INSERT INTO account (username, password, agent_id) VALUES ("'+req.body.username+'", "'+hash+'", 0001)', (err)=>{
        if (err) throw err;
        res.redirect('/dashboard');
    })
})

app.get('/login', (req, res)=>{
    res.render('login');
})

app.post('/auth', urlencodedParser, (req, res)=>{
    connection.query('SELECT * FROM account JOIN agent ON account.agent_id = agent.id WHERE username = "'+req.body.username+'"', (err, response)=>{
        if (err) throw err;
        if(response.length>0){
            if(bcrypt.compareSync(req.body.userpassword, response[0]['password'])){
                req.session.loggedin = true;
                req.session.username = response[0]['agent_name'];
                req.session.user = response[0]['account_img'];
                connection.query('SELECT username from account WHERE username = "'+req.body.username+'" AND password = "'+req.body.userpassword+'"', (err, response, result)=>{
                    if(err) throw err;
                })
                res.redirect('/dashboard');
            }else{
                res.send('Incorrect username or password');
            }
        }else
        res.end();        
    })
})


app.get('/dashboard', urlencodedParser, (req, res)=>{ 
    if(req.session.loggedin){
        connection.query('SELECT COUNT(id) as total FROM purchase_order UNION ALL SELECT COUNT(id) FROM order_delivery UNION ALL SELECT COUNT(id) FROM client UNION ALL SELECT COUNT(id) FROM item', (err, rows)=>{
            if(err) throw err;
            res.render('dashboard', {data:rows, user:req.session.username, userimg:req.session.user});
        })
    }else{
        res.redirect('/login');
    }    
})

//CLIENTS
app.get('/clients', (req, res)=>{
    if(req.session.loggedin){
        connection.query('SELECT client_name, client_address, client_email, client_contact_person, client_contact_no FROM client WHERE is_active = 1', (err, result)=>{
            res.render('clients', {data: result, user:req.session.username, userimg:req.session.user});
        })
    }else{
        res.redirect('/login');
    } 
})

app.get('/client-add', (req, res)=>{
    if(req.session.loggedin){
        res.render('client-add', {user:req.session.username, userimg:req.session.user});
    }else{
        res.redirect('/login');
    }
})

app.post('/addclient', urlencodedParser, (req, res)=>{
    if(req.session.loggedin){
        let salt = bcrypt.genSaltSync(saltRounds);
        let hash = bcrypt.hashSync(req.body.password, salt);
        connection.query('INSERT INTO client (client_name, client_address, client_email, client_account_password, client_contact_person, client_contact_no, is_approved) VALUES ("'+req.body.clientName+'", "'+req.body.clientAddress+'", "'+req.body.clientEmail+'", "'+hash+'", "'+req.body.contactPerson+'", "'+req.body.contactNumber+'", 1)', (err)=>{
            if(err) throw err;
            res.redirect('clients');
        })
    }else{
        res.redirect('/login');
    }
})

app.get('/client-request', (req, res)=>{
    if(req.session.loggedin){
        connection.query('SELECT id, client_name, client_address, client_email, client_contact_person, client_contact_no, client_account_password FROM client WHERE is_approved = 0', (err, result)=>{
            res.render('client-request', {data: result, user:req.session.username, userimg:req.session.user});
        })
    }else{
        res.redirect('/login');
    }
})


app.post('/client-approval', urlencodedParser, (req, res)=>{
    if(req.session.loggedin){
        let salt = bcrypt.genSaltSync(saltRounds);
        let hash = bcrypt.hashSync(req.body.clientPassword, salt);
        connection.query('UPDATE client SET client_account_password = "'+hash+'", is_approved = 1, is_active = 1 WHERE id = "'+req.body.clientID+'"', (err, response)=>{
            if(err) throw err;
            res.redirect('/client-request');
        })
    }else{
        res.redirect('/login');
    }
})


//AGENTS
app.get('/agents', (req, res)=>{
    if(req.session.loggedin){
        connection.query('SELECT id, agent_name, agent_contact FROM agent', (err, result)=>{
            if(err) throw err;
            res.render('agents', {data:result, user:req.session.username, userimg:req.session.user});
        })
    }else{
        res.redirect('/login');
    }  
})

app.get('/agent-add', (req, res)=>{
    if(req.session.loggedin){
        res.render('agent-add', {user:req.session.username, userimg:req.session.user});
    }else{
        res.redirect('/login');
    }
})

app.post('/addAgent', urlencodedParser, (req, res)=>{
    if(req.session.loggedin){
        connection.query('INSERT INTO agent (id, agent_name, agent_contact) VALUES("'+generateUUID()+'", "'+req.body.agentName+'", "'+req.body.agentContact+'")', (err)=>{
            if(err) throw err;
            res.render('agent-add', {user:req.session.username, userimg:req.session.user});
        })
    }else{
        res.redirect('/login');
    } 
})


//PRODUCTS
app.get('/products', (req, res)=>{
    if(req.session.loggedin){
        connection.query("SELECT item.id, item.item_name, item.item_description, FORMAT(item.unit_price,2) AS 'price', item.item_type, item.item_img, GROUP_CONCAT(DISTINCT tag.tag_descript SEPARATOR ', ') AS 'genre', GROUP_CONCAT(DISTINCT book_author.book_author SEPARATOR ', ') AS 'authors' FROM item INNER JOIN book_author INNER JOIN item_tag INNER JOIN tag ON item.id = book_author.item_id AND item_tag.item_no = item.id AND item_tag.tag_id = tag.id AND item.is_deleted = 0 GROUP BY item.item_name", (err, result)=>{
            if(err) throw err;
            res.render('products', {prod:result, user:req.session.username, userimg:req.session.user});
        })
    }else{
        res.redirect('/login');
    } 
})

app.get('/product-add', (req, res)=>{
    if(req.session.loggedin){
        connection.query("SELECT * FROM tag", (err, result)=>{
            if(err) throw err;
            res.render('product-add', {user:req.session.username, userimg:req.session.user, tag:result});
        })
    }else{
        res.redirect('/login');
    }
})


app.post('/addItem', urlencodedParser, (req,res)=>{
    connection.beginTransaction((err)=>{
        connection.query('INSERT INTO item(item_name, item_description, unit_price, item_type, item_img) VALUES (?,?,?,?,?);', 
        [req.body.itemName, req.body.itemDescription, req.body.itemPrice, req.body.itemType, `/assets/sourced/${req.body.itemImg}`], (err,result)=>{
            if(err) throw err;
            book_id = result.insertId;
            connection.query('INSERT INTO book_author(item_id, book_author) VALUES (?, ?);',
            [book_id, req.body.itemAuthor], (err) => {
                if (err) throw err;
            })
            connection.query('INSERT INTO item_tag(item_no, tag_id) VALUES ?;',
            [req.body.itemTag.map((tag)=>[book_id, tag])], (err) => {
                if (err) throw err;
            })
            connection.commit((err) => {
                if (err) throw err;
                res.redirect('/product-add');
            })
            console.log(req.body.itemImg);
        })
    })
})

app.post('/updatePrice', urlencodedParser, (req,res)=>{
    if(req.session.loggedin){
        connection.query('UPDATE item SET unit_price = "'+req.body.newPrice+'", date_updated = "'+jsonNow+'" WHERE item.id = "'+req.body.item_id+'"', (err)=>{
            if(err) throw err;
            res.redirect('/products');
        })
    }else{
        res.redirect('/login');
    }
})

app.post('/deleteItem', urlencodedParser, (req,res)=>{
    if(req.session.loggedin){
        connection.query('UPDATE item SET is_deleted = 1, date_deleted = "'+jsonNow+'" WHERE item.id = "'+req.body.itemID+'"', (err)=>{
            if(err) throw err;
            res.redirect('/products');
        })
    }else{
        res.redirect('/login');
    }
})

//ORDERS

app.get('/orders', (req, res)=>{
    if(req.session.loggedin){
        let query = 'SELECT purchase_order.id as id, (SUM(total_qty) OVER (PARTITION BY purchase_order.id)) as total_qty,(SUM(total_price) OVER (PARTITION BY purchase_order.id)) as total_price, item_id, item_name, total_qty as qty, total_price as item_price, client_name, client_contact_person, agent_id, purchase_date, purchase_status FROM purchase_order_detail INNER JOIN purchase_order ON purchase_order.id = purchase_order_detail.purchase_order_no INNER JOIN client ON client.id = purchase_order.client_id INNER JOIN item ON item.id = purchase_order_detail.item_id';
        connection.query(query, (err, orders) => {
            if(err) throw err;
            let result = new Map();
            for (order of orders) {
                if (!(result.has (order.id))){
                    result.set(order.id,[order])
                } else {
                    result.get(order.id).push(order)
                }
            }
            res.render('orders', {orderss: result, user: req.session.username, userimg:req.session.user});
        })
    }else{
        res.redirect('/login');
    } 
})

//DELIVERY
app.get('/deliveries', (req, res)=>{
    if(req.session.loggedin){
        connection.query('SELECT order_delivery.id as id, delivery_no, item_no, item_name, unit_price, purchase_order_no, order_date_received, client_name, agent_name, qty_delivered, (SUM(qty_delivered) OVER (PARTITION BY order_delivery.id)) as total_qty, (SUM(total_price) OVER (PARTITION BY order_delivery.id)) as total_price, delivery_received_by FROM order_delivery INNER JOIN order_delivery_detail ON order_delivery.id = order_delivery_detail.delivery_no INNER JOIN client ON client.id = order_delivery.client_id INNER JOIN agent ON agent.id = order_delivery.agent_id INNER JOIN item ON item.id = order_delivery_detail.item_no', (err, deliverys)=>{
            if(err) throw err;
            let result = new Map();
            for (delivery of deliverys) {
                if (!(result.has (delivery.id))){
                    result.set(delivery.id,[delivery])
                } else {
                    result.get(delivery.id).push(delivery)
                }
            }
            res.render('deliveries', {deliveryss: result, user: req.session.username, userimg:req.session.user});
        })
    }else{
        res.redirect('/login');
    } 
})

app.get('/delivery-add', (req, res)=>{
    if(req.session.loggedin){
        connection.query('SELECT purchase_order.id, purchase_order.client_id, client.client_name FROM `purchase_order` INNER JOIN client ON client.id = purchase_order.client_id WHERE purchase_status = 0', (err, result)=>{
            if(err) throw err;
            res.render('delivery-add', {order:result, user:req.session.username, userimg:req.session.user});
        }) 
    }else{
        res.redirect('/login');
    }
})

app.post('/adddelivery', urlencodedParser, (req,res)=>{
    if(req.session.loggedin){
        connection.query('START TRANSACTION; INSERT INTO order_delivery(order_date_received, client_id, purchase_order_no, agent_id) SELECT ?, client_id, purchase_order.id, agent_id FROM purchase_order WHERE purchase_order.id = ?; SET @deliveryid = last_insert_id(); INSERT INTO order_delivery_detail(delivery_no, item_no, qty_delivered, total_price, delivery_received_by) SELECT @deliveryid, item_id, total_qty, total_price, ? FROM purchase_order_detail WHERE purchase_order_no = ?; UPDATE purchase_order SET purchase_status = 1, date_updated = ? WHERE id = ?; COMMIT;',
        [req.body.dateDelivered, req.body.orderId, req.body.receipient, req.body.orderId, req.body.dateDelivered, req.body.orderId], (err)=>{
            if(err) throw err;
            res.redirect('deliveries');
        
        })
    }else{
        res.redirect('/login');
    }   
})


app.get('/logout', (req, res)=>{
    req.session.destroy(function(err){
        res.redirect('/login');
    })
})

app.listen(3000);