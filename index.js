const matlab = require("node-matlab");
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());
app.use(cors());

app.get("/",(req,res)=>{
    res.send("<h1> Hello </h1>")
})
function getCodeX(s){
  s = s.trim()
  switch(s){
    case "Time" :
      return 1
    case "Interstory Displacement" :
      return 2
    case "IDR":
      return 3
      default:
        return 1
  }
}

function getCodeY(s){
  s = s.trim()
  /*2 - Ground Acceleration
3 - Displacement
4 - Interstory Disp
5 - IDR
6 - Velocity
7 - Total Acceleration
8 - Restoring Force
9 - Base Shear*/
  switch(s){
    case "Ground Acceleration":
      return 2
    case "Displacement":
      return 3
    case "Interstory Disp":
     return 4
     case "IDR":
      return 5
    case "Velocity":
      return 6
    case "Total Acceleration":
    return 7
    case "Restoring Force":
      return 8
    case "Base Shear":
    return 9
    default :
    return 4
  }
}
let base = "https://raw.githubusercontent.com/aryan-sri-harsha/EarthquakeData/main"
app.post("/sesmic",(req,res)=>{
  let x = getCodeX(req.body.x)
  let y = getCodeY(req.body.y)
  let gnd = req.body.gm 
  res.json({
    request : true,
    url : `${base}/${gnd}/${x+'_'+y}.png`
  });
// GM1/1_2.png
})

const port = process.env.PORT || 5000;
app.listen(port, () => {
  console.log(`server is up and running on ${port}`)
});
// matlab
//   .run("fn(10,20)")
//   .then((result) => console.log(result))
//   .catch((error) => console.log(error));