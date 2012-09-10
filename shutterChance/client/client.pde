import processing.video.*;
import java.awt.image.*;
import javax.imageio.*;

Capture cap;
int count = 10;
int INTERVAL = 3;
String api = "http://ascension.chi.mag.keio.ac.jp/test/";
PImage img;
HttpClient client;

void setup(){
  size(1024,768);
  background(0);
  cap = new Capture(this,1024,768);
  frameRate(1);
}

void draw(){
  
  if(cap.available() && count == INTERVAL){
    cap.read();
    img = cap;
    image(cap,0,0);
    String mon,d,h,m,s;
    mon = zerofill(month());
    d = zerofill(day());
    h = zerofill(hour());
    m = zerofill(minute());
    s = zerofill(second());
    String folderName = "./images/"+year()+"/"+mon+d+"/";
    String fileName = h+m+s+".jpg";  
    String path = folderName + fileName;
    save(path);
    httpPost();
    count = 0;
  }
  count += 1;
}

String zerofill(int num){
  if(num < 10){
    return "0"+num;
  }else{
    return ""+num;
  }
}

void httpPost(){
  client = new DefaultHttpClient(); 
  client.getParams().setParameter(CoreProtocolPNames.PROTOCOL_VERSION, HttpVersion.HTTP_1_1);
  HttpPost post = new HttpPost(api);
  
  ContentBody cb = new ByteArrayBody(getImagesBytes(img),"image/jpeg","hogefuga.jpg");
  MultipartEntity entity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
  entity.addPart("image", cb);
  post.setEntity(entity);
  try{
    HttpResponse response = client.execute(post);
    println(response.getStatusLine());
  }catch(IOException e){
    println(e);
  }
  
}

byte[] getImagesBytes(PImage _img){
  BufferedImage image = (BufferedImage)(_img.getImage());
  ByteArrayOutputStream bos = new ByteArrayOutputStream();
  BufferedOutputStream os = new BufferedOutputStream(bos);
  try{
    image.flush();
    ImageIO.write(image,"png",os);
    os.flush();
    os.close();
    
  }catch(IOException e){
    println(e); 
  }
  return bos.toByteArray();
}
