const express = require("express");
const mysql = require("mysql");
const bodyParser = require("body-parser");
const bcrypt = require("bcrypt");
const saltRounds = 10;
// const session = require("express-session");
const urlencodedParser = bodyParser.urlencoded({extended: false});
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
    multipleStatements: true,
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "linarf",
    dateStrings: true
});

connection.connect((err)=>{
    if (err) throw err;
    console.log("Database connected");
})




var now = moment();
var jsonNow = now.toJSON();

app.get('/dashboard', (req, res)=>{
    res.render('dashboard');
})

//CLIENTS
app.get('/clients', (req, res)=>{
    connection.query('SELECT client_name, client_address, client_email, client_contact_person, client_contact_no FROM client WHERE is_active = 1', (err, result)=>{
        res.render('clients', {data: result});
    })
})

app.get('/client-add', (req, res)=>{
    res.render('client-add');
})

app.post('/addclient', urlencodedParser, (req, res)=>{
    let salt = bcrypt.genSaltSync(saltRounds);
    let hash = bcrypt.hashSync(req.body.password, salt);
    connection.query('INSERT INTO client (client_name, client_address, client_email, client_account_password, client_contact_person, client_contact_no, is_approved) VALUES ("'+req.body.clientName+'", "'+req.body.clientAddress+'", "'+req.body.clientEmail+'", "'+hash+'", "'+req.body.contactPerson+'", "'+req.body.contactNumber+'", 1)', (err)=>{
        if(err) throw err;
        res.redirect('clients');
    })
})

app.get('/client-request', (req, res)=>{
    connection.query('SELECT id, client_name, client_address, client_email, client_contact_person, client_contact_no, client_account_password FROM client WHERE is_approved = 0', (err, result)=>{
        res.render('client-request', {data: result});
    })
})


app.post('/client-approval', urlencodedParser, (req, res)=>{
    let salt = bcrypt.genSaltSync(saltRounds);
    let hash = bcrypt.hashSync(req.body.clientPassword, salt);
    connection.query('UPDATE client SET client_account_password = "'+hash+'", is_approved = 1, is_active = 1 WHERE id = "'+req.body.clientID+'"', (err, response)=>{
        if(err) throw err;
        res.redirect('/client-request');
    })
})


//AGENTS
app.get('/agents', (req, res)=>{
    connection.query('SELECT id, agent_name, agent_contact FROM agent', (err, result)=>{
        if(err) throw err;
        res.render('agents', {data:result});
    })
})

app.get('/agent-add', (req, res)=>{
    res.render('agent-add');
})

app.post('/addAgent', urlencodedParser, (req, res)=>{
    connection.query('INSERT INTO agent (id, agent_name, agent_contact) VALUES("'+req.body.agentID+'", "'+req.body.agentName+'", "'+req.body.agentContact+'")', (err)=>{
        if(err) throw err;
        res.render('agent-add');
    })
})


//PRODUCTS
app.get('/products', urlencodedParser, (req, res)=>{
    connection.query('SELECT * FROM item WHERE is_deleted=0', (err, result)=>{
        if(err) throw err;
        res.render('products', {prod:result});
    })
})

app.get('/product-add', (req, res)=>{
    res.render('product-add');
})

app.post('/addItem', urlencodedParser, (req,res)=>{
    connection.query('START TRANSACTION; INSERT INTO item(item_name, item_description, unit_price, item_type, item_img) VALUES ("'+req.body.itemName+'", "'+req.body.itemDescription+'", "'+req.body.itemPrice+'", "'+req.body.itemType+'", "'+req.body.itemImg+'"); SET @bookid = last_insert_id(); INSERT INTO book_author(item_id, book_author) VALUES (@bookid, "'+req.body.itemAuthor+'"); INSERT INTO item_tag(item_no,`tag_id`) VALUES (@bookid, "'+req.body.itemTag+'"); COMMIT ;', (err)=>{
        if(err) throw err;
        res.redirect('/product-add');
    })
})


//ORDERS
app.get('/orders', (req, res)=>{
    connection.query('SELECT purchase_order.id as id, item_id, total_qty, total_price, client_name, agent_id, purchase_date, purchase_status FROM ((purchase_order INNER JOIN purchase_order_detail ON purchase_order.id = purchase_order_detail.purchase_order_no) INNER JOIN client ON client.id = purchase_order.client_id);', (err, result)=>{
        if(err) throw err;
        res.render('orders', {order:result});
    })

    
})

app.get('/order-add', (req, res)=>{
    res.render('order-add');
})


//DELIVERY
app.get('/deliveries', (req, res)=>{
    connection.query('SELECT delivery_no, purchase_order_no, order_date_received, client_name, agent_name, qty_delivered, total_price, delivery_received_by FROM (((order_delivery INNER JOIN order_delivery_detail ON order_delivery.id = order_delivery_detail.delivery_no) INNER JOIN client ON client.id = order_delivery.client_id)) INNER JOIN agent ON agent.id = order_delivery.agent_id;', (err, result)=>{
        if(err) throw err;
        res.render('deliveries', {delivery:result});
    })
})

app.get('/delivery-add', (req, res)=>{
    res.render('delivery-add');
})

app.post('/adddelivery', urlencodedParser, (req,res)=>{
    connection.query('START TRANSACTION; INSERT INTO order_delivery(order_date_received, client_id, purchase_order_no, agent_id) SELECT ?, client_id, purchase_order.id, agent_id FROM purchase_order WHERE purchase_order.id = ?; SET @deliveryid = last_insert_id(); INSERT INTO order_delivery_detail(delivery_no, item_no, qty_delivered, total_price, delivery_received_by) SELECT @deliveryid, item_id, total_qty, total_price, ? FROM purchase_order_detail WHERE purchase_order_no = ?; COMMIT;',
    [req.body.dateDelivered, req.body.orderId, req.body.receipient, req.body.orderId], (err)=>{
        if(err) throw err;
        res.redirect('/deliveries');
    })
})

app.listen(3000);