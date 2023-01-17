var express = require('express');

var app = express();

app.set('view engine', 'ejs');

app.get('/', function(req, res){
    res.render('pages/newLogin');
});

app.get('/register', function(req, res){
    res.render('pages/register');
});

app.get('/profile', function(req, res){
    res.render('pages/profile');
});

app.get('/eventprofile', function(req, res){
    res.render('pages/eventprofile');
});

app.get('/locationprofile', function(req, res){
    res.render('pages/locationprofile');
});

app.get('/home', function(req, res){
    res.render('pages/homepage');
});

app.get('/profileOther', function(req, res){
    res.render('pages/profileOther');
});
app.listen(5000);