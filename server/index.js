var app = require("express")();
var http = require('http').createServer(app);
var io = require('socket.io')(http);


//TODO: User Register
//TODO: User money
//TODO: Waiting Room
//TODO: When press play send user to waiting room


var waitingRoom = io.of("/waitingRoom");
//var gameRooms = io.of("/gameRooms");
var users = ["salihcnkhy"];


io.on("connect", (socket) => {

    // XXX: data = {username : string}
    socket.on("register", (data) => {
        // TODO: Check username available If it is emit 'username exist' , If not emit 'success'
        if (!users.includes(data.username)) {
            users.push(data.username);
            socket.emit("register", true);

        } else {
            socket.emit("register", false);
        }
    });

});

var waitingUserSockets = [];
var rooms = [];
waitingRoom.on("connect", (socket) => {
    // TODO : emit to user YOU ARE IN WAITING ROOM
    // XXX: When the user connect here add the user to waiting user list 
    // XXX: If two users in waiting room emit them the game room namespace but first 

    if (!waitingUserSockets.includes(socket)) {
        console.log("somebody connected");
        waitingUserSockets.push(socket);
    }

    if (waitingUserSockets.length >= 2) {
        const sockets = [waitingUserSockets.shift(), waitingUserSockets.shift()];
        console.log("Users Ready for game");
        // TODO: Create a room give all listeners here then add the room to the rooms list 
        var randomRoomName = "gameRoom_" + rooms.length.toString();
        var room_nps = io.of("/gameRooms/" + randomRoomName);
        room_nps.on("connect", (socket) => {

            console.log("somebody connected to " + randomRoomName);
            // get words from db
            var words = ["ALIEN", "MORTAL COMBAT", "THE LEGEND OF ZELDA", "CYBERPUNK 2077"];
            var controlListCount = 0;
            socket.on("getWord", () => {

                if (controlListCount == 2) {
                    console.log(JSON.stringify(words));

                    var randomIndex = Math.floor(Math.random() * words.length);
                    var word = words[randomIndex];
                    words.splice(randomIndex, 1);

                    console.log("new Words");

                    console.log(JSON.stringify(words));
                    room_nps.emit("setWord", word);

                    console.log("word send " + word);
                    controlListCount = 0;

                } else {
                    controlListCount++;
                    console.log(controlListCount.toString() + " Control Count");
                }
            });



            //TODO: Add listeners here
        });
        // Probably it wont be like that but for this time you could keep it as a placeholder
        rooms.push(randomRoomName);

        sockets.forEach(socket => {
            //room infos
            socket.emit("isGameStarting", randomRoomName);
        });


    }

});
/* gameRooms.on("connect", (socket) => {
    // data.roomId
    socket.on("JoinRoom", (data) => {

        socket.join(data.roomId);

    });


}); */

let port_no = 3000;
http.listen(port_no, "192.168.1.105", () => {
    console.log('listening on *:' + port_no.toString());
});