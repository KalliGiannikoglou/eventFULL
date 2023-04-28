var express = require('express');

var app = express();

const jwt = require('jsonwebtoken');
//require('crypto').randomBytes(64).toString('hex')
// '09f26e402586e2faa8da4c98a35f1b20d6b033c6097befa8be3486a829587fe2f90a832bd3ff9d42710a4da095a2ce285b009f0c3730cd9b8e1af3eb84df6611'
const cookieParser = require('cookie-parser');
app.use(cookieParser());
const dotenv = require('dotenv');
// get config vars
dotenv.config();
// access config var
process.env.TOKEN_SECRET;

const exphbs = require('express-handlebars'); // updated to 6.0.X
const fileUpload = require('express-fileupload');

app.use(fileUpload());

// Static Files
app.use(express.static('public'));
app.use(express.static('uploads'));

/*function authenticateToken(req, res, next) {
    //const authHeader = req.headers['authorization']
    //const token = authHeader && authHeader.split(' ')[1]
    const token = req.headers["authorization"];
    console.log(token)
    if (token == null) return res.sendStatus(401)

    jwt.verify(token, (process.env.TOKEN_SECRET) , (err, user) => {
        console.log(err)

        if (err) return res.sendStatus(403)

        req.user = user

        next()
    })
}
*/
const verifyJWT = (req, res, next) => {
    //const authHeader = req.headers['authorization'];
    //if (!authHeader) return res.sendStatus(401);
    //console.log(authHeader); // Bearer token
    //const token = authHeader.split(' ')[1];
    const token = req.cookies.jwt;
    // jwt.decode(token).username;
   
    jwt.verify(
        token,
        process.env.REFRESH_TOKEN_SECRET,
        (err, decoded) => {
            if (err){
                res.render('pages/newLogin')
                // next()
            }
            //invalid token
            else{
                req.user = decoded.username;
                next();
            }
            
        }
    );
}

function generateAccessToken(username) {
    return jwt.sign(username, process.env.ACCESS_TOKEN_SECRET, { expiresIn: '300s' });
  }
function generateRefreshToken(username) {
    return jwt.sign(username, process.env.REFRESH_TOKEN_SECRET, { expiresIn: '1 d' });
  }

var bodyParser = require('body-parser')
app.use( bodyParser.json() );       // to support JSON-encoded bodies
app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
  extended: true
})); 

app.use(express.json());       // to support JSON-encoded bodies
//app.use(express.urlencoded()); // to support URL-encoded bodies

app.set('view engine', 'ejs');

const Pool = require('pg').Pool
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'eventfulldb',
    password: '1234',
    port: 5432,
})

const bcrypt = require('bcryptjs');

const path = require('path');
const { title } = require('process');
app.use('/static', express.static(path.join(__dirname, 'public')));

app.get('/', function(req, res){
    res.render('pages/newLogin');
});

app.get('/newevent', verifyJWT, async function(req, res){
    var locations = await locationList();
    res.render('pages/createevent', {
        locations: locations.rows
    });
});

async function locationList(){
    try {
        const res = await pool.query(`select location_name, location_id from location`);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}


app.get('/newlocation', verifyJWT, function(req, res){
    res.render('pages/createlocation');
});

app.get('/register', function(req, res){
    res.render('pages/register');
});

app.get('/profile', verifyJWT, async function(req, res){
    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;
    
    var info = await getUserInfo(username)
    var requests = await getFriendRequest(info.rows[0].user_id)
    var interested = await getInterestedEvents(info.rows[0].user_id)
    var interestedOld = await getInterestedEventsOld(info.rows[0].user_id)
    var organised = await getOrganisedEvents(info.rows[0].user_id)
    var organisedOld = await getOrganisedEventsOld(info.rows[0].user_id)
    var followed = await followedList(info.rows[0].user_id)
    var follows = await followsList(info.rows[0].user_id)
   
    res.render('pages/profile', {
        user_id: info.rows[0].user_id,
        username: username,
        bio: info.rows[0].bio, 
        social_media: info.rows[0].social_media,
        requests: requests.rows,
        InterestedNew: interested.rows,
        InterestedOld: interestedOld.rows,
        OrganisedNew: organised.rows,
        OrganisedOld: organisedOld.rows,
        followed: followed.rows,
        follows: follows.rows,
        image: info.rows[0].user_photo
    });
    
});

async function followedList(id){
    try {
        const res = await pool.query(`SELECT * FROM follows inner join users on follows.fk1_user_id = users.user_id WHERE fk2_user_id = $1`, [id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}


async function followsList(id){
    try {
        const res = await pool.query(`SELECT * FROM follows inner join users on follows.fk2_user_id = users.user_id WHERE fk1_user_id = $1`, [id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getOrganisedEvents(user_id){
    try {
        const res = await pool.query(`select * from event where fk2_user_id = $1 and date >= (select current_date) order by date,time asc`, [user_id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getOrganisedEventsOld(user_id){
    try {
        const res = await pool.query(`select * from event where fk2_user_id = $1 and date < (select current_date) order by date,time asc`, [user_id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getUserInfo(username) {        
    try {
        const res = await pool.query(`SELECT * FROM users WHERE username = $1`,[username]
    );
    return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getFriendRequest(user_id) {           
    try {
        const res = await pool.query('SELECT * FROM request inner join users on request.fk1_user_id = users.user_id WHERE fk2_user_id = $1;',[user_id]
    );
    return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

app.post('/invite', async function(req, res) {
    const token = req.cookies.jwt;
    const username1 = jwt.decode(token).username;
    var user_id1 = await getUserId(username1);

    var user_id2 = req.body.data.user_id;
    var info = await getUserInfoId(user_id2)
    var username2 = info.rows[0].username;

    var event_id = req.body.data.event_id;

    try{
        await insert_invitation(username1, username2, user_id1, user_id2, event_id);
    }
    catch(err){
        console.log(err)
    }
   

});

async function insert_invitation(username1, username2, id1, id2, event_id){

    try{
       await pool.query('INSERT INTO invite(username1, username2, fk1_user_id, fk2_user_id, fk3_event_id) VALUES ($1, $2, $3, $4, $5) RETURNING *', [username1, username2, id1, id2, event_id])
    }
    catch (err){
        console.log(err)
        throw err
    }
}


app.get('/eventprofile/*', verifyJWT, async function(req, res){
    var id = req.url.replace("/eventprofile/","").replace("?","");
    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;

    var user_id = await getUserId(username);
    var eventInfo = await getEvent(id);
    var interested = await interestedUsers(id);
    var prevComments = await getPrevComments(id);
    var invite = await inviteUser(user_id, id);
    var notInvite = await notInviteUser(user_id, id);
    var myInvitation = await getInvitations(user_id, id);
    var locations = await locationList();

    var flagOrganiser = 0;
    if(eventInfo.rows[0].organiser_name === username){
        flagOrganiser = 1;
    }
   
    res.render('pages/eventprofile', {
        event: eventInfo.rows[0],
        interested: interested.rows,
        prevComments: prevComments.rows,
        invite: invite.rows,
        notInvite : notInvite.rows,
        myInvitation : myInvitation.rows,
        flagOrganiser: flagOrganiser,
        locations: locations.rows
    });

});

async function getInvitations(user_id, event_id){
    try {
        const res = await pool.query(`select * from invite inner join users on invite.fk1_user_id = users.user_id
        where fk2_user_id = $1 and fk3_event_id= $2`, [user_id, event_id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function inviteUser(user_id, event_id){
    try {
        const res = await pool.query(`select * from follows inner join users on follows.fk2_user_id = users.user_id where fk1_user_id=$1 and username2 not in 
        (select username2 from invite where fk1_user_id = $2 and fk3_event_id=$3)`, [user_id, user_id, event_id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function notInviteUser(user_id, event_id){
    try {
        const res = await pool.query(`select * from follows inner join users on follows.fk2_user_id = users.user_id where fk1_user_id=$1 and username2 in 
        (select username2 from invite where fk1_user_id = $2 and fk3_event_id=$3)`, [user_id, user_id, event_id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getEvent(id){
    try {
        const res = await pool.query(`select * from event where event_id = $1 order by date,time asc`, [id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getPrevComments(id){
    try {
        const res = await pool.query(`select * from eventcomments where fk1_event_id = $1`, [id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function interestedUsers(id){
    try {
        const res = await pool.query(`select * from interested inner join users on interested.fk1_user_id = users.user_id where fk2_event_id = $1`, [id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

app.get('/locationprofile/*' ,verifyJWT, async function(req, res){
    const id = await req.url.replace("/locationprofile/","").replace("?","");
    const location= await getLocationInfo(id);
    const events = await getLocationEvents(id);
    const comments = await getLocationComments(id);

    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;
    var flagOwn = 0;
    if(location.rows[0].username === username){
        flagOwn = 1;
    }
   
    res.render('pages/locationprofile',{
        location: location.rows,
        events: events.rows,
        prevComments: comments.rows,
        flagOwner: flagOwn
    });
});

async function getLocationInfo(id){
    try {
        const res = await pool.query(`SELECT * FROM location WHERE location_id = $1`, [id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getLocationEvents(id){
    try {
        const res = await pool.query(`SELECT * FROM event WHERE fk1_location_id = $1 and date >= (select current_date) order by date,time asc`, [id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getLocationComments(id){
    try {
        const res = await pool.query(`SELECT * FROM locationcomments WHERE fk1_location_id = $1`, [id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}


app.get('/search/*', async function(req, res){
    const url = decodeURI(req.url);
    var search = url.replace("/search/","").replace("?","").replace("%20", " ");
   
    var users = await searchUser('%'+ search+'%');
    var events = await searchEvent('%'+ search+'%');
    var locations = await searchLoc('%'+ search+'%');
    
    
    res.render('pages/search',{
        users: users.rows,
        events: events.rows,
        locations: locations.rows
    });

});

async function searchUser(username){
    try {
        const res = await pool.query(`select * from users where username ilike $1 `, [username]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function searchEvent(eventTitle){
    try {
        const res = await pool.query(`select * from event where event_title ilike $1 `, [eventTitle]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function searchLoc(location_name){
    try {
        const res = await pool.query(`select * from location  where location_name ilike  $1 `, [location_name]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}


app.get('/home', verifyJWT, async function(req, res){
    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;
    
    var allEvents = await getAllEvents();
    var user_id = await getUserId(username);
    var interestedEvents = await getInterestedEvents(user_id);
    var invitedEvents = await getInvitedEvents(user_id);
   
    res.render('pages/homepage', {
        allEvents: allEvents.rows,
        interestedEvents: interestedEvents.rows,
        invitedEvents: invitedEvents.rows
    });
});

app.post('/filteredevents',verifyJWT, async function(req, res){
    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;

    var allEvents = await getAllEvents();

    var filters = req.body;
    var array = [];
    
    //if all filters are false -> no filters applied -> return all events
    if(!filters.theatre && !filters.music && !filters.kids && !filters.food &&
        !filters.cinema && !filters.dance && !filters.exhibition && !filters.drinks){
            allEvents.rows.forEach((event)=>{
                array.push(event.event_id);
            })
    }
    
    allEvents.rows.forEach((event)=>{
        if(filters.theatre && event.z_theatre){
            array.push(event.event_id);            
        }
        else if(filters.music && event.z_music){
            array.push(event.event_id);
        }
        else if(filters.kids && event.z_kids){
            array.push(event.event_id);
        }
        else if(filters.food && event.z_food){
            array.push(event.event_id);
        }
        else if(filters.cinema && event.z_cinema){
            array.push(event.event_id);
        }
        else if(filters.dance && event.z_dance){
            array.push(event.event_id);
        }
        else if(filters.exhibition && event.z_exhibition){
            array.push(event.event_id);
        }
        else if(filters.drinks && event.z_drinks){
            array.push(event.event_id);
        }
    })   
    res.status(200).send(array);

});

async function getAllEvents(){
    try {
        const res = await pool.query(`SELECT * FROM event where date >= (select current_date) order by date,time asc `);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getInterestedEvents(user_id){
    try {
        const res = await pool.query(`select * from event where date >= (select current_date) AND event_id IN
        (select fk2_event_id from interested where fk1_user_id = $1) order by date,time asc`, [user_id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getInterestedEventsOld(user_id){
    try {
        const res = await pool.query(`select * from event where date < (select current_date) AND event_id IN
        (select fk2_event_id from interested where fk1_user_id = $1) order by date,time asc`, [user_id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getInvitedEvents(user_id){
    try {
        const res = await pool.query(`SELECT  DISTINCT ON (event.event_id) event.*, 
        (SELECT COUNT(*) FROM invite WHERE invite.fk2_user_id = $1 and invite.fk3_event_id = event.event_id ) 
        from event inner join invite on event.event_id =  invite.fk3_event_id and invite.fk3_event_id in  
        (SELECT fk3_event_id from invite where fk2_user_id = $2 ) and event.date >= (select current_date)`, [user_id, user_id]) ;
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

app.get('/profileOther/*', verifyJWT, async function(req, res){
    var id1 = req.url.replace("/profileOther/","").replace("?","");

    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;
    var id2 = await getUserId(username);

    var info = await getUserInfoId(id1);
    var organised = await getOrganisedEvents(info.rows[0].user_id)
    var organisedOld = await getOrganisedEventsOld(info.rows[0].user_id)

    if(id1 != id2){ 
        var follows = await followsListCommon(id1, id2)
        var followed = await followedListCommon(id1, id2)
        var isfol = await isFollower(id2,id1);
        var hasreq = await hasRequested(id2,id1);
        var flag;
        if(hasreq.rowCount != 0){
            flag = 2
        }
        else if(isfol.rowCount != 0 ){
            flag = 1;
        }
        else{
            flag = 0;
        }
       
        res.render('pages/profileOther', {
            user: info.rows,
            OrganisedNew: organised.rows,
            OrganisedOld: organisedOld.rows,
            follows: follows.rows,
            followed: followed.rows,
            flag: flag
        });
    }
    else{   //redirect to my profile
        var requests = await getFriendRequest(info.rows[0].user_id)
        var interested = await getInterestedEvents(info.rows[0].user_id)
        var interestedOld = await getInterestedEventsOld(info.rows[0].user_id)
        var followed = await followedList(info.rows[0].user_id)
        var follows = await followsList(info.rows[0].user_id)

        res.render('pages/profile', {
            username: username,
            bio: info.rows[0].bio, 
            social_media: info.rows[0].social_media,
            requests: requests.rows,
            InterestedNew: interested.rows,
            InterestedOld: interestedOld.rows,
            OrganisedNew: organised.rows,
            OrganisedOld: organisedOld.rows,
            followed: followed.rows,
            follows: follows.rows,
            image: info.rows[0].user_photo
        });
       
    }
});


async function isFollower(id1, id2){
    try {
        const res = await pool.query(`select * from follows where fk1_user_id = $1 and fk2_user_id = $2`, [id1, id2]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function hasRequested(id1, id2){
    try {
        const res = await pool.query(`select * from request where fk1_user_id = $1 and fk2_user_id = $2`, [id1, id2]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}


async function followsListCommon(id1, id2){
    try {
        const res = await pool.query(`SELECT v2.username2 FROM follows v1 INNER JOIN follows v2 ON (v1.fk2_user_id = v2.fk2_user_id) WHERE v1.fk1_user_id = $1 AND v2.fk1_user_id = $2`, [id1, id2]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}


async function followedListCommon(id1, id2){
    try {
        const res = await pool.query(`SELECT v2.username1 FROM follows v1 INNER JOIN follows v2 ON (v1.fk1_user_id = v2.fk1_user_id) WHERE v1.fk2_user_id = $1 AND v2.fk2_user_id = $2`, [id1, id2]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getUserInfoId(id) {        
    try {
        const res = await pool.query(`SELECT * FROM users WHERE user_id = $1`,[id]
    );
    return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}


app.post('/loginData', function(req, res) {
    var username = req.body.data.username,
        password = req.body.data.password;
   
    pool.query('SELECT password FROM users WHERE username = $1;', [username],async function (err, result, fields) {
        // if any error while executing above query, throw error
        if (err) throw err;
        // if there is no error, you have the result
        var hash = result.rows[0].password;
        console.log(hash);
        var comp = comparePassword(password, hash);
        console.log(comp)

        if(comp){
            const refresh_token = generateRefreshToken({ username });
            console.log('making cookies')

            res.cookie('jwt',refresh_token, { httpOnly: true, sameSite: 'None', secure: true, maxAge: 24 * 60 * 60 * 1000 })
            
            //res.clearCookie('world2', { httpOnly: true, sameSite: 'None', secure: true });
            res.json({  });

           
           
        }else{
            console.log("else")
            res.clearCookie('jwt', { httpOnly: true, sameSite: 'None', secure: true });
            res.json({  });
            // res.render('pages/newLogin')

        }
    })
}); 
   
app.get('/logout',function(req, res) {
    res.clearCookie('jwt', { httpOnly: true, sameSite: 'None', secure: true });
    // res.json({  });
    res.render('pages/newLogin')
});

app.post('/registerData', function(req, res) {
    var email = req.body.data.email,
        username = req.body.data.username,
        password = req.body.data.password;
        user_photo = 'defaultUser.png'

    var hash = hashPassword(password);
    
    pool.query('INSERT INTO users (username, email, password, user_photo) VALUES ($1, $2, $3, $4) RETURNING *', [username, email, hash, user_photo], (error, results) => {
        if (error) {
            throw error
        }
        res.status(201).send(`User added with ID: ${results.rows[0].user_id}`)
    })
});

remove_friend_request
app.post('/acceptrequest', async function(req, res) {
    var req_username = req.body.data.req_username;
    
    const token = req.cookies.jwt;
    const followed_username = jwt.decode(token).username;
   
    const [id_req, id_followed] = await Promise.all([await getUserId(req_username), await getUserId(followed_username)]);
   
    //await insert_followed(req_username, followed_username, id_req, id_followed);
    await insert_follows(req_username, followed_username, id_req, id_followed);
    await remove_friend_request(id_req, id_followed);
});


app.post('/removerequest', async function(req, res) {
    var req_username = req.body.data.req_username;
    
    const token = req.cookies.jwt;
    const followed_username = jwt.decode(token).username;
    const [id_req, id_followed] = await Promise.all([await getUserId(req_username), await getUserId(followed_username)]);
    await remove_friend_request(id_req, id_followed);
});


async function insert_follows(username1, username2, id1, id2){

    try{
       await pool.query('INSERT INTO follows(username1, username2, fk1_user_id, fk2_user_id) VALUES ($1, $2, $3, $4) RETURNING *', [username1, username2, id1, id2])
    }
    catch (err){
        console.log(err)
        throw err
    }
}

async function remove_friend_request(id1, id2){

    try{
       await pool.query('DELETE FROM request WHERE fk1_user_id = $1 AND fk2_user_id = $2', [id1, id2])
    }
    catch (err){
        console.log(err)
        throw err
    }
}

app.post('/sendRequest', async function(req, res) {
    var reqUsername = req.body.data.username;
    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;

    try{
        const [curr_user_id, req_user_id] = await Promise.all([await getUserId(username), await getUserId(reqUsername)]);
        await newRequest(curr_user_id, req_user_id, username, reqUsername);
        res.status(200)
    }
    catch (err){
        console.log(err)
        res.status(500)
    }  
});


async function newRequest(curr_user_id, req_user_id, username1, username2){
    try{
        await  pool.query('INSERT INTO request(fk1_user_id, fk2_user_id, username1, username2) VALUES ($1, $2, $3, $4)', [curr_user_id, req_user_id, username1, username2])
    
    }
    catch (err){
        console.log(err)
        throw err
    }
}

app.post('/removeFollower', async function(req, res) {
    var reqUsername = req.body.data.username;
    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;

    try{
        curr_user_id = await getUserId(username)
        req_user_id = await getUserId(reqUsername)
        await removeFol(curr_user_id, req_user_id)
        res.status(200)
    }
    catch (err){
        console.log(err)
        res.status(500)
    }  
});

async function removeFol(id1, id2){

    try{
       await pool.query('DELETE FROM follows WHERE fk1_user_id = $1 AND fk2_user_id = $2', [id1, id2])
    }
    catch (err){
        console.log(err)
        throw err
    }
}

app.post('/editProfile', function(req, res) {
    var bio = req.body.data.bio,
        socialMedia = req.body.data.socialMedia;

    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;

    if(bio !== '' && socialMedia !== ''){
        pool.query('UPDATE users SET bio = $1, social_media = $2 where username = $3', [bio, socialMedia, username], (error, results) => {
            if (error) {
                throw error
            }
            res.status(200)
        })
    }
    
    else if(bio !== ''){
        pool.query('UPDATE users SET bio = $1 where username = $2', [bio, username], (error, results) => {
            if (error) {
                throw error
            }
            res.status(200)
        })
    }
    else if(socialMedia !== ''){
        pool.query('UPDATE users SET social_media = $1 where username = $2', [socialMedia, username], (error, results) => {
            if (error) {
                throw error
            }
            res.status(200)
        })
    }
});

app.post('/editEvent', async function(req, res) {
    var event_id = req.body.data.event_id,
    description = req.body.data.description,
    locationId = req.body.data.locationId,
    dateEvent = req.body.data.dateEvent,
    timeEvent = req.body.data.timeEvent;

    var locationEvent = await getLocationName(locationId);
    locationEvent = locationEvent.rows[0].location_name;

    if(dateEvent !== ''){
        await pool.query('UPDATE event SET date = CAST($1 AS DATE) where event_id = $2', [dateEvent, event_id], (error, results) => {
            if (error) {
                throw error
            }
            res.status(200)
        })
    }
    if(description !== ''){
        await pool.query('UPDATE event SET description = $1 where event_id = $2', [description, event_id], (error, results) => {
            if (error) {
                throw error
            }
            res.status(200)
        })
    }
    //fk1_location_id, time, date, location_name,
    if(locationEvent !== ''){
        await pool.query('UPDATE event SET location_name = $1, fk1_location_id = $2 where event_id = $3', [locationEvent, locationId, event_id], (error, results) => {
            if (error) {
                throw error
            }
            res.status(200)
        })
    }
    if(timeEvent !== ''){
        await pool.query('UPDATE event SET time = CAST($1 AS TIME) where event_id = $2', [timeEvent, event_id], (error, results) => {
            if (error) {
                throw error
            }
            res.status(200)
        })
    }
});

app.post('/deleteEvent', async function(req, res) {
    var eventId = req.body.data.eventId;

    await pool.query('DELETE FROM event WHERE event_id = $1', [eventId], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200)
    })
   
});

app.post('/editProfilePhoto', async function(req, res) {
    let sampleFile;
    let uploadPath;
    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;
    const user_id = await getUserId(username);
  
    if (!req.files || Object.keys(req.files).length === 0) {
      return res.status(400).send('No files were uploaded.');
    }
  
    // name of the input is sampleFile
    sampleFile = req.files.sampleFile;
    uploadPath = __dirname + '/uploads/' +"user" +user_id +sampleFile.name;

    nameofimage = "user" +user_id +sampleFile.name
    console.log(nameofimage);

    pool.query('UPDATE users SET user_photo = $1 where user_id = $2', [nameofimage, user_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200)
    })
  
    // Use mv() to place file on the server
    sampleFile.mv(uploadPath, function (err) {
      if (err) return res.status(500).send(err);
    });


});



app.post('/editEventPhoto/*', async function(req, res) {
    var event_id = req.url.replace("/editEventPhoto/","").replace("?","");
    let sampleFile;
    let uploadPath;
    
    if (!req.files || Object.keys(req.files).length === 0) {
      return res.status(400).send('No files were uploaded.');
    }
  
    // name of the input is sampleFile
    sampleFile = req.files.sampleFile;
    uploadPath = __dirname + '/uploads/' +"event" + event_id +sampleFile.name;

    nameofimage = "event" + event_id +sampleFile.name;
    console.log(nameofimage);

    pool.query('UPDATE event SET event_photo = $1 where event_id = $2', [nameofimage, event_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200)
    });
  
    // Use mv() to place file on the server
    sampleFile.mv(uploadPath, function (err) {
      if (err) return res.status(500).send(err);
    });
});


app.post('/editLocationPhoto/*', async function(req, res) {
    var location_id = req.url.replace("/editLocationPhoto/","").replace("?","");
    let sampleFile;
    let uploadPath;
    
    if (!req.files || Object.keys(req.files).length === 0) {
      return res.status(400).send('No files were uploaded.');
    }
  
    // name of the input is sampleFile
    sampleFile = req.files.sampleFile;
    uploadPath = __dirname + '/uploads/' + "location" + location_id +sampleFile.name;

    nameofimage = "location" + location_id +sampleFile.name;
    console.log(nameofimage);

    pool.query('UPDATE location SET location_photo = $1 where location_id = $2', [nameofimage, location_id], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200)
    });
  
    // Use mv() to place file on the server
    sampleFile.mv(uploadPath, function (err) {
      if (err) return res.status(500).send(err);
    });
});


app.post('/addEvent', async function(req, res) {
    var titleEvent = req.body.data.titleEvent,
        description = req.body.data.description,
        locationId = req.body.data.locationId,
        dateEvent = req.body.data.dateEvent,
        timeEvent = req.body.data.timeEvent,
        theatre =  req.body.data.theatre,
        music = req.body.data.music,
        kids = req.body.data.kids,
        food = req.body.data.food,
        cinema = req.body.data.cinema,
        dance = req.body.data.dance,
        exhibition = req.body.data.exhibition,
        drinks = req.body.data.drinks;

    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;
    var event_photo = 'defaultEvent.png';

    try{
        const user_id = await getUserId(username);
        var locationEvent = await getLocationName(locationId);
        locationEvent = locationEvent.rows[0].location_name
       
        await newEvent(titleEvent, user_id, description, locationId, timeEvent, dateEvent, locationEvent, username,
                        cinema, dance, music, kids, food, exhibition, drinks, theatre, event_photo);
        res.status(200)
    }
    catch (err){
        console.log(err)
        res.status(500)
    }  
});


async function newEvent(titleEvent, user_id, description, location_id, timeEvent, dateEvent, location, organiser, 
                        cinema, dance, music, kids, food, exhibition, drinks, theatre, event_photo){

    try{
        await pool.query('INSERT INTO event (event_title, fk2_user_id, description, fk1_location_id, time, date, location_name, organiser_name, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, z_theatre, event_photo) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)', [titleEvent, user_id, description, location_id, timeEvent, dateEvent, location, organiser, cinema, dance, music, kids, food, exhibition, drinks, theatre, event_photo])
    }
    catch (err){
        console.log(err)
        throw err
    }
    
}

async function getLocationName(id) {
            
    try {
        const res = await pool.query(
            `SELECT location_name FROM location WHERE location_id = $1`,[id]);
        return res;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}
        
async function getUserId(username) {
            
    try {
        const res = await pool.query(
            `SELECT user_id FROM users WHERE username = $1`,[username]
        );
        return res.rows[0].user_id;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getEventId(event_name) {
            
    try {
        const res = await pool.query(
            `SELECT event_id FROM event WHERE event_title = $1`, [event_name]
        );
        return res.rows[0].event_id;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}

async function getLocationId(name) {
            
    try {
        const res = await pool.query(
            `SELECT location_id FROM location WHERE  location_name= $1`,[name]
        );
        return res.rows[0].location_id;
    } catch (err) {
        console.log(err)
        throw(err)
    }
}


app.post('/interestedEvent', async function(req, res) {
    var event_id = req.body.data.event_id;
    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;

    try{
        const [user_id] = await Promise.all([await getUserId(username)]);
        await newInterest(event_id, user_id, username);
        res.status(200)
    }
    catch (err){
        console.log(err)
        res.status(500)
    }  
});

async function newInterest( event_id, user_id, username){

    try{
        await  pool.query('INSERT INTO interested(fk1_user_id, fk2_event_id, username) VALUES ($1, $2, $3)', [ user_id, event_id, username])
    
    }
    catch (err){
        console.log(err)
        throw err
    }
}

app.post('/commentEvent', async function(req, res) {
    //var user_id = req.url.replace("/commentEvent/","");
    var event_id = req.body.data.event_id;
    var comment = req.body.data.comment;
    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;
    var user_id = await getUserId(username);

    //console.log(event_id, comment, user_id);
    if(comment != ''){
        await newEventComment(event_id, user_id, comment, username);
    }
    
    res.status(200);
});

function newEventComment(event_id, user_id, comment, username){
    return new Promise((resolve) => {
    try{
        pool.query('INSERT INTO eventComments(fk2_user_id, fk1_event_id, commenttext, username) VALUES ($1, $2, $3, $4)', [ user_id, event_id, comment, username])
        
    }
    catch (err){
        console.log(err)
        throw err
    }
});
}

app.post('/commentLocation', async function(req, res) {
    
    var location_id = req.body.data.location_id;
    var comment = req.body.data.comment;
    const token = req.cookies.jwt;
    const username = jwt.decode(token).username;
    var user_id = await getUserId(username);

    if(comment != ''){
        await newLocationComment(location_id, user_id, comment, username);
    }
    
    res.status(200);
});


async function newLocationComment(location_id, user_id, comment, username){

    try{
        await  pool.query('INSERT INTO locationComments(fk2_user_id, fk1_location_id, commenttext, username) VALUES ($1, $2, $3, $4)', [ user_id, location_id, comment, username])
    }
    catch (err){
        console.log(err)
        throw err
    }
}


app.post('/editLocation', async function(req, res) {
    var name = req.body.data.name,
        address = req.body.data.address,
        phone = req.body.data.phone

    var location_id = await getLocationId(name);
    //console.log(location_id);

    if(address !== ''){
        await pool.query('UPDATE location SET address = $1 where location_id = $2', [address, location_id], (error, results) => {
            if (error) {
                throw error
            }
            res.status(200)
        })
    }
    if(phone !== ''){
        await pool.query('UPDATE location SET phone = $1 where location_id = $2', [phone, location_id], (error, results) => {
            if (error) {
                throw error
            }
            res.status(200)
        })
    }

    res.sendStatus(200);
});

app.post('/addLocation', function(req, res) {
    var name = req.body.data.name,
        address = req.body.data.address,
        phone = req.body.data.phone,
        parking = req.body.data.parking,
        indoor = req.body.data.indoor,
        wc = req.body.data.wc,
        accessible = req.body.data.accessible,
        transportation = req.body.data.transportation,
        outdoor = req.body.data.outdoor,
        pets = req.body.data.pets;
    var location_photo = 'defaultLocation.png'
    
    pool.query('INSERT INTO location (location_photo, location_name, address, phone, z_parking, z_transportation, z_accessible, z_outdoor, z_indoor, z_wc, z_pets) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)', [location_photo, name, address, phone, parking, transportation, accessible, outdoor, indoor, wc, pets], (error, results) => {
        if (error) {
            throw error
        }
        res.status(200)
    })
    res.sendStatus(200);
});




function hashPassword(password) {
    let salt = bcrypt.genSaltSync(10);
    let hash = bcrypt.hashSync(password, salt);
    return hash;
}

function comparePassword(password, hash) {
    let res = bcrypt.compareSync(password, hash);
    return res;
}


app.listen(5000);