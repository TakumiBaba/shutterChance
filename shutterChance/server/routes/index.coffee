fs = require 'fs'

exports.index = (req, res) ->

  res.render 'index'
    req: req

exports.failed = (req, res) ->
  res.render '404'
    req: req

exports.test = (req, res)->
  zerofill = (n)->
    if n<10
      return "0"+n
    else
      return n
  t = new Date()
  y = t.getFullYear()
  m = zerofill t.getMonth()+1
  d = zerofill t.getDate()
  h = zerofill t.getHours()
  min = zerofill t.getMinutes()
  s = zerofill t.getSeconds()
  unixtime = Math.ceil t.getTime()/1000
  fs.readFile req.files.image.path, (err, data)->
    newPath = "./public/images/background/"+unixtime+".jpg"
    fs.writeFile newPath,data, (err, data)->
      if err
        console.log err
      console.log newPath;
      console.log 'saved!'
  res.render 'index'
    req: req

exports.imagesjson = (req,res)->
  res.contentType "application/json"
  res.header("Access-Control-Allow-Origin", "*");

  photos = []
  fileExistFlag = false
  if req.params.time is "now"
    requestTime = "now"
  else
    requestTime = Number req.params.time
  requestNum  = Number req.params.num
  imageDir = fs.readdirSync './public/images/background/'
  imageDir = imageDir.sort()
  count = imageDir.length-(requestNum+1)
  if requestTime is "now"
    fileExistFlag = true
    count = imageDir.length-(requestNum+1)
  if imageDir && requestTime isnt "now"
    for file,i in imageDir
      fileName = file.split "."
      fileUnixTime = fileName[0]
      if(requestTime <= fileUnixTime)
        count = i
        fileExistFlag = true
        break

  if !fileExistFlag
    res.json []
  else
    for i in [0..requestNum-1]
      if imageDir[count+i] isnt undefined
        photos.push {url: "http://ascension.chi.mag.keio.ac.jp/images/background/"+imageDir[count+i]}
    #photos.reverse()
    res.json photos


exports.iineUpload = (req,res)->
  t = new Date()
  unixtime = Math.ceil t.getTime()/1000
  fs.readFile req.files.image.path, (err, data)->
    newPath = "./public/images/like/"+unixtime+".jpg"
    fs.writeFile newPath,data, (err, data)->
      if err
        console.log err
      console.log 'saved!'
  res.render 'index'
    req: req
exports.iineJson = (req,res)->
  res.contentType "application/json"
  res.header("Access-Control-Allow-Origin", "*");
  json = []
  imagesDir = fs.readdirSync "./public/images/like/"
  imagesDir = imagesDir.sort()
  json.push "http://ascension.chi.mag.keio.ac.jp/images/like/"+imagesDir[imagesDir.length-1]
  res.json json

exports.iineInit = (req,res)->
  res.contentType "application/json"
  res.header("Access-Control-Allow-Origin", "*");
  json = []
  imagesDir = fs.readdirSync "./public/images/like/"
  imagesDir = imagesDir.sort()
  for key in imagesDir
    json.push "http://ascension.chi.mag.keio.ac.jp/images/like/"+key
  res.json json
