// piggy at Revision 2012 by Floppy

#ifdef GL_ES
precision mediump float;
#endif



uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;




float randv(vec2 r) {
    return fract(sin(dot(r.xy, vec2(13.432, 15.233))) * 23000.5453);
}
float rand(float r) {
    return fract(sin(r*13.432) * 23000.5453);
}
float circle(float x, float y, float R)
{
   if(sqrt(x*x+y*y)<R) 
      return 1.0;
   else 
      return 0.00;
}
float circledist(float x, float y, float R)
{
   return abs(sqrt(x*x+y*y)-R);
}
float circledistin(float x, float y, float R)
{
   float r = sqrt(x*x+y*y);
   if(r<R) 
      return R-r;
   
   return 0.00;
}

float circlegrad(float x, float y, float R)
{
   float r = sqrt(x*x+y*y);
   if(r<R) 
      return 12.0-12.0*r/R;
   else 
      return 0.00;
}
float circleflower(float x, float y, float R)
{
   float r = sqrt(x*x+y*y);
   float phi = atan(y/x);
   r += (0.01)*sin(12.0*phi);
   r += 0.05*rand(12.0*phi)*sin(12.0*phi);
   if(r<R) 
      return 2.0-2.0*r/R;
   else 
      return 0.00;
}

float circleplama(float x, float y, float R, float f, float A)
{
   float r = sqrt(x*x+y*y);
   float phi = atan(y/x);
   r -= A*sin(f*phi);
   if(r<R) 
      return 1.0;
   else 
      return 0.00;
}


float rect(float x, float y, float sx, float sy, float a, float b)
{
   if(x>sx && x<a && y>sy && y<b) 
      return 1.0;
   else 
      return 0.0;
}

vec3 hand(float x, float y, vec3 col, vec3 pink)
{
   float c;
   float a;
   a=-1.1;
   c = rect((x)*cos(a)-sin(a)*(y)-0.249,sin(a)*(x)+cos(a)*(y)+0.613, 0.35, 0.53, 0.38, 0.538);
   col = col*(1.0-c) + pink*c;
   a=0.7;
   c = rect((x)*cos(a)-sin(a)*(y)+0.444,sin(a)*(x)+cos(a)*(y)-0.103, 0.35, 0.53, 0.38, 0.538);
   col = col*(1.0-c) + pink*c;
   a=0.02;
   c = rect((x)*cos(a)-sin(a)*(y)+0.0,sin(a)*(x)+cos(a)*(y)-0.0, 0.326, 0.528, 0.351, 0.538);
   col = col*(1.0-c) + pink*c;
   return col;
}
vec3 foot2(float x, float y, vec3 col, vec3 black)
{

   float c;
   c = rect((x-0.54)*0.7+0.05,(y-0.324)*1.4+0.06,0.02,0.02,0.06,0.06);
   col = col*(1.0-c) + black*c;
   c = rect((x-0.54)*1.2+0.02,(y-0.324)*0.8+0.04,0.02,0.02,0.06,0.06);
   col = col*(1.0-c) + black*c;
   return col;
}
vec3 foot(float x, float y, vec3 col, vec3 black)
{
   float c;
   c = circle((x-0.537)*2.4-0.04,(y-0.324)*0.9,0.03)*(1.0-circle((x-0.54)*0.8,(y-0.344)*2.2,0.03))*(1.0-circle((x-0.54)*0.8,(y-0.289)*2.2,0.03));
   col = col*(1.0-c) + black*c;
   return col;
}


vec3 kropla(float x, float y, vec3 col, vec3 black)
{
   float c;
   c = circle((x-0.54)*1.2,(y-0.324)*3.6,0.03);
   col = col*(1.0-c) + black*c;
   c = circle((x-0.53)*1.4,(y-0.324)*2.8,0.03);
   col = col*(1.0-c) + black*c;
   return col;
}


vec3 head(float x, float y, vec3 col, vec3 pink, vec3 pinkp, vec3 lips, vec3 black, vec3 white, float glass, float beard, float rzesy, float mouth,float oczy)
{
   float c;
   // ear left
   c = circle((x-0.49)*2.1,(y-0.82)*1.0,0.04);
   col = col*(1.0-c) + pinkp*c;
   c = circle((x-0.49)*2.1,(y-0.82)*1.0,0.03);
   col = col*(1.0-c) + pink*c;
   // ear right
   c = circle((x-0.56)*2.1,(y-0.79)*1.0,0.04);
   col = col*(1.0-c) + pinkp*c;
   c = circle((x-0.56)*2.1,(y-0.79)*1.0,0.03);
   col = col*(1.0-c) + pink*c;
   // ear1
   float circle21 = circle((x-0.5)*1.6*y,(y-0.69)*0.97,0.105-0.002*glass);
   col = col*(1.0-circle21) + pinkp*circle21;
   float circle2 = circle((x-0.5)*1.6*y,(y-0.69)*0.97,0.1);
   col = col*(1.0-circle2) + pink*circle2;
   // lips 
   c = circle((x-0.47)*1.6*y,(y-0.66)*0.97,0.038);
   col = col*(1.0-c) + lips*c;
   c = circle((x-0.47)*1.6*y,(y-0.66)*0.97,0.032);
   col = col*(1.0-c) + pink*c;
   c = circle((x-0.46)*1.6*y,(y-0.68)*0.97,0.032);
   col = col*(1.0-c) + pink*c;
   c = circle((x-0.49)*1.6*y,(y-0.68)*0.97,0.032);
   col = col*(1.0-c) + pink*c;
//   if(mouth!=0.0)
//   {
      c = circle((x-0.47)*1.6*y,(y-0.66)*0.97,0.034) * (1.0-circle((x-0.47)*0.9*y-0.002,(y-0.66)*0.70-0.023*mouth+0.000,0.034));
      col = col*(1.0-c) + lips*c;
      c = circle((x-0.47)*1.6*y,(y-0.66)*0.97,0.034) * (1.0-circle((x-0.47)*1.0*y-0.002,(y-0.66)*0.70-0.02*mouth+0.000,0.034));
      col = col*(1.0-c) + black*c;
//   }

   // nose
   c = circle((x-0.45)*1.3*y,(y-0.75)*1.9,0.105)*(1.0-circle((x-0.5)*1.6*y,(y-0.69)*0.97,0.105));
   col = col*(1.0-c) + pinkp*c;
   c = circle((x-0.45)*1.3*y,(y-0.75)*1.9,0.1);
   col = col*(1.0-c) + pink*c;
   // nose end
   c = circle((x-0.366)*5.2*y,(y-0.747)*2.8,0.1);
   col = col*(1.0-c) + pinkp*c;
   c = circle((x-0.366)*5.2*y,(y-0.747)*2.8,0.08);
   col = col*(1.0-c) + pink*c;
   // nose holes
   c = circle((x-0.355)*0.2,(y-0.745)*0.2,0.0013);
   col = col*(1.0-c) + lips*c;
   c = circle((x-0.375)*0.2,(y-0.745)*0.2,0.0013);
   col = col*(1.0-c) + lips*c;
   // glasses
   if(glass!=0.0)
   {
      // palka ucho
      float a = -0.08;
      c = rect((x)*cos(a)-sin(a)*(y)-0.11,sin(a)*(x)+cos(a)*(y)+0.050, 0.444, 0.75, 0.524, 0.759);
      col = col*(1.0-c) + pink*0.75*c;
      c = rect((x)*cos(a)-sin(a)*(y)-0.11,sin(a)*(x)+cos(a)*(y)+0.049, 0.444, 0.75, 0.522, 0.757);
      col = col*(1.0-c) + pink*0.25*c;
      c = rect((x)*cos(a)-sin(a)*(y)-0.11,sin(a)*(x)+cos(a)*(y)+0.048, 0.444, 0.75, 0.52, 0.755);
      col = col*(1.0-c) + black*c;
      // left okular
      c = circle((x-0.425)*3.4,(y-0.762)*3.4,0.079);
      col = col*(1.0-c) + pink*0.75*c;
      c = circle((x-0.425)*3.4,(y-0.762)*3.4,0.076);
      col = col*(1.0-c) + black*c;
      c = circle((x-0.425)*3.4,(y-0.762)*3.4,0.06);
      col = col*(1.0-c) + pink*c;

      // right okular
      c = circle((x-0.475)*3.4,(y-0.753)*3.4,0.079);
      col = col*(1.0-c) + pink*0.75*c;
      c = circle((x-0.475)*3.4,(y-0.753)*3.4,0.076);
      col = col*(1.0-c) + black*c;
      c = circle((x-0.475)*3.4,(y-0.753)*3.4,0.06);
      col = col*(1.0-c) + pink*c;
      // palka miedzy
      c = rect(x,y, 0.447, 0.755, 0.455, 0.76);
      col = col*(1.0-c) + black*c;
   }
   // eye1
   float circle14 = circle((x-0.475)*1.0,(y-0.75)*1.0,0.015);
   col = col*(1.0-circle14) + pinkp*circle14;
   float circle4 = circle((x-0.475)*1.0,(y-0.75)*1.0,0.0115);
//   col = col*(1.0-circle4) + white*circle4;
   float b=0.0; if(rzesy==1.0) b=pow(0.5 + 0.5*sin(2.0*time),20.0+rand(time)*10.0); // magic function by iq
   col = col*(1.0-circle4) + (white*(1.0-b)+b*pink)*circle4;

   float circle15 = circle((x-0.425)*1.0,(y-0.76)*1.0,0.015);
   col = col*(1.0-circle15) + pinkp*circle15;
   float circle5 = circle((x-0.425)*1.0,(y-0.76)*1.0,0.0115);
   col = col*(1.0-circle5) + (white*(1.0-b)+b*pink)*circle5;


   // OCZY
   float circle6,circle7;
   //if(oczy==0.0) // mama
   {
      circle6 = circle((x-0.47)*1.0,(y-0.744)*1.0,0.00554);
      circle7 = circle((x-0.42)*1.0,(y-0.754)*1.0,0.0055);
   }

   col = col*(1.0-circle6) + (black*(1.0-b)+b*pink)*circle6;   
   col = col*(1.0-circle7) + (black*(1.0-b)+b*pink)*circle7;


   // rush
   vec3 pink2 = vec3(252.0,140.0,212.0)/255.0;
   c = circle((x-0.54)*1.4,(y-0.674)*0.9,0.023);
   col = col*(1.0-c) + pink2*c;

   // beard
   vec3 beardcol=vec3(167,93,68)/255.0;
   float a = -1.3;
   if(beard!=0.0)
   {
      a=-1.21;
      c = rect((x)*cos(a)-sin(a)*(y)-0.321,sin(a)*(x)+cos(a)*(y)+0.617, 0.440, 0.45, 0.460, 0.4525);
      col = col*(1.0-c) + beardcol*c;
      a = -1.3;
      c = rect((x)*cos(a)-sin(a)*(y)-0.311,sin(a)*(x)+cos(a)*(y)+0.718, 0.440, 0.45, 0.460, 0.4525);
      col = col*(1.0-c) + beardcol*c;
      a=-1.5;
      c = rect((x)*cos(a)-sin(a)*(y)-0.241,sin(a)*(x)+cos(a)*(y)+0.888, 0.442, 0.45, 0.460, 0.451);
      col = col*(1.0-c) + beardcol*c;
      a=-1.8;
      c = rect((x)*cos(a)-sin(a)*(y)-0.081,sin(a)*(x)+cos(a)*(y)+1.088, 0.441, 0.45, 0.460, 0.452);
      col = col*(1.0-c) + beardcol*c;
      a=-1.79;
      c = rect((x)*cos(a)-sin(a)*(y)-0.081,sin(a)*(x)+cos(a)*(y)+1.088, 0.445, 0.45, 0.460, 0.4512);
      col = col*(1.0-c) + beardcol*c;

      a=-1.31;
      c = rect((x)*cos(a)-sin(a)*(y)-0.251,sin(a)*(x)+cos(a)*(y)+0.718, 0.446, 0.45, 0.460, 0.4515);
      col = col*(1.0-c) + beardcol*c;
      a=-1.51;
      c = rect((x)*cos(a)-sin(a)*(y)-0.181,sin(a)*(x)+cos(a)*(y)+0.888, 0.445, 0.45, 0.460, 0.452);
      col = col*(1.0-c) + beardcol*c;
      a=-1.79;
      c = rect((x)*cos(a)-sin(a)*(y)-0.081,sin(a)*(x)+cos(a)*(y)+1.088, 0.445, 0.45, 0.460, 0.451);
      col = col*(1.0-c) + beardcol*c;
      a=-1.69;
      c = rect((x)*cos(a)-sin(a)*(y)-0.086,sin(a)*(x)+cos(a)*(y)+1.01, 0.445, 0.45, 0.460, 0.4513);
      col = col*(1.0-c) + beardcol*c;

   }

   if(rzesy!=0.0)
   {
      a = -1.1;
      c = rect((x)*cos(a)-sin(a)*(y)-0.455,sin(a)*(x)+cos(a)*(y)+0.542, 0.440, 0.45, 0.455, 0.4525);
      col = col*(1.0-c) + black*c;
      a = -1.51;
      c = rect((x)*cos(a)-sin(a)*(y)-0.351,sin(a)*(x)+cos(a)*(y)+0.8818, 0.440, 0.45, 0.455, 0.4525);
      col = col*(1.0-c) + black*c;
      a = -2.01;
      c = rect((x)*cos(a)-sin(a)*(y)-0.051,sin(a)*(x)+cos(a)*(y)+1.198, 0.440, 0.45, 0.455, 0.4525);
      col = col*(1.0-c) + black*c;

      a = -1.1;
      c = rect((x)*cos(a)-sin(a)*(y)-0.415,sin(a)*(x)+cos(a)*(y)+0.532, 0.440, 0.45, 0.455, 0.4525);
      col = col*(1.0-c) + black*c;
      a = -1.51;
      c = rect((x)*cos(a)-sin(a)*(y)-0.311,sin(a)*(x)+cos(a)*(y)+0.8818, 0.440, 0.45, 0.455, 0.4525);
      col = col*(1.0-c) + black*c;
      a = -2.01;
      c = rect((x)*cos(a)-sin(a)*(y)-0.008,sin(a)*(x)+cos(a)*(y)+1.20, 0.440, 0.45, 0.455, 0.4525);
      col = col*(1.0-c) + black*c;

      a = -1.1;
      c = rect((x)*cos(a)-sin(a)*(y)-0.455+0.012,sin(a)*(x)+cos(a)*(y)+0.542-0.05, 0.440, 0.45, 0.455, 0.4525);
      col = col*(1.0-c) + black*c;
      a = -1.51;
      c = rect((x)*cos(a)-sin(a)*(y)-0.351-0.003,sin(a)*(x)+cos(a)*(y)+0.8818-0.05, 0.440, 0.45, 0.455, 0.4525);
      col = col*(1.0-c) + black*c;
      a = -2.01;
      c = rect((x)*cos(a)-sin(a)*(y)-0.051-0.03,sin(a)*(x)+cos(a)*(y)+1.198-0.040, 0.440, 0.45, 0.455, 0.4525);
      col = col*(1.0-c) + black*c;

      a = -1.1;
      c = rect((x)*cos(a)-sin(a)*(y)-0.415+0.012,sin(a)*(x)+cos(a)*(y)+0.532-0.05, 0.440, 0.45, 0.455, 0.4525);
      col = col*(1.0-c) + black*c;
      a = -1.51;
      c = rect((x)*cos(a)-sin(a)*(y)-0.311-0.003,sin(a)*(x)+cos(a)*(y)+0.8818-0.05, 0.440, 0.45, 0.455, 0.4525);
      col = col*(1.0-c) + black*c;

   }

   return col;
}

vec3 body(float x, float y, vec3 col, vec3 pink, vec3 pinkp, vec3 pepadres, vec3 pepadresp, float male, float recerazem)
{
   float c;

   float prz=0.14*recerazem+male*0.1-recerazem*male*0.14;
   y=y+prz;
   float a=-0.4;
   c = rect((x)*cos(a)-sin(a)*(y)-0.18,sin(a)*(x)+cos(a)*(y)+0.19, 0.35, 0.53, 0.46, 0.54);
   col = col*(1.0-c) + pink*c;
   col = hand(x,y, col, pink);
   y=y-prz;

   // body
   float circle12 = circle((x-0.5)*0.9,(y-0.4)/2.5,0.103);
   if(y>0.39 || male!=0.0)
   col = col*(1.0-circle12) + pepadresp*circle12;
   float circle1 = circle((x-0.5)*0.9,(y-0.4)/2.5,0.1);
   if(y>0.4 || male!=0.0)
   col = col*(1.0-circle1) + pepadres*circle1;

   if(recerazem==1.0)
   {
      x = 1.1-x;
   }
      y=y+prz;
     
   

//   if(recerazem==0)
//   {
      //arm2
      a=0.4;
      c = rect((x)*cos(a)-sin(a)*(y)+0.02,sin(a)*(x)+cos(a)*(y)-0.19, 0.35, 0.53, 0.41, 0.54);
      col = col*(1.0-c) + pink*c;
      // hand 2
      col = hand(1.0-x+0.0025,y+0.011, col, pink);
      return col;
//   }
}

vec3 legs(float x, float y, vec3 col, vec3 pink, vec3 black, vec3 gray, float poziom, vec3 kalosze, float full)
{
   float c;

   //shadow
   if(poziom==1.0)
   {    
   } 
   else
   {
      c = .8*circleplama((x-0.486)*0.8,(y-0.319)*3.5,0.1,10.0,0.004);
      col = col*(1.0-c) + gray*c;
   }

   //leg1
   c = rect(x,y, 0.55, 0.33, 0.56, 0.39);
   col = col*(1.0-c) + pink*c;
   //foot1
   col = foot(x,y,col,kalosze);
   if(full!=0.0) col = foot2(x,y,col,kalosze);
   //leg2
   c = rect(x,y, 0.45, 0.33, 0.46, 0.39);
   col = col*(1.0-c) + pink*c;
   //foot2
   col = foot(x+0.1,y,col,kalosze);
   if(full!=0.0) col = foot2(x+0.1,y,col,kalosze);

   //shadow
   if(poziom==1.0)
   {
      c = .8*circleplama((x-0.586)*1.2,(y-0.416)*0.5,0.1,6.0,0.004);
      col = col*(1.0-c) + gray*c;     
   } 
   else
   {
      c = .8*circleplama((x-0.486)*0.8,(y-0.316)*12.5,0.1,10.0,0.004);
      col = col*(1.0-c) + gray*c;
   }


   return col;
}


vec3 mama(float x, float y, vec3 col, vec3 pink, vec3 pinkp, vec3 lips, vec3 black, vec3 white, vec3 pepadres, vec3 pepadresp, vec3 gray, vec3 kalosze, float rzesy)
{
   col = legs(x,y, col, pink, black, gray,0.0, kalosze,0.0);
   col = body(x,y+0.04, col, pink, pinkp, pepadres, pepadres/1.14,0.0,0.0);
   col = head(x,y+0.04, col, pink, pinkp, lips, black, white, 0.0,0.0,rzesy,0.0,0.0);

   float c;
   if(rzesy!=0.0)
   for(float z=1.0; z>0.0; z-=0.1)
   {
      c = circleplama(x*6.4-3.07,y*6.4-2.95,0.24+(0.1*z),6.0,0.035);
      col = pepadres*(0.9+z*0.12)*(c) + (col)*(1.0-c);
   }
   return col;

}

vec3 pepa(float x, float y, vec3 col, vec3 pink, vec3 pinkp, vec3 lips, vec3 black, vec3 white, vec3 pepadres, vec3 pepadresp, vec3 gray, vec3 kalosze)
{
   col = legs(x,y-0.04, col, pink, black, gray,0.0, kalosze,0.0);
   col = body(x,y, col, pink, pinkp, pepadres, pepadres/1.14,0.0,0.0);
   col = head(x,y, col, pink, pinkp, lips, black, white, 0.0,0.0,0.0,0.7,1.0);
   // plama
   float c = circleplama((x-0.56)*0.9,(y-0.459)*1.5,0.01,16.0,0.004);
   col = col*(1.0-c) + pepadres*0.9*c;
   return col;
}

vec3 george(float x, float y, vec3 col, vec3 pink, vec3 pinkp, vec3 lips, vec3 black, vec3 white, vec3 pepadres, vec3 pepadresp, vec3 gray, float mouth, vec3 kalosze)
{
   col = legs(x,y+0.08, col, pink, black, gray,0.0, kalosze,0.0);
   col = body(x*0.96+0.02,y*1.8-0.36, col, pink, pinkp, pepadres, pepadres/1.14,1.0,0.0);
   col = head(x*0.8+0.1,y*0.8+0.17, col, pink, pinkp, lips, black, white,0.0,0.0,0.0,mouth,2.0);
   return col;
}

vec3 george2(float x, float y, vec3 col, vec3 pink, vec3 pinkp, vec3 lips, vec3 black, vec3 white, vec3 pepadres, vec3 pepadresp, vec3 gray, float mouth, vec3 kalosze)
{
   col = body(x*0.96+0.02,y*1.8-0.36, col, pink, pinkp, pepadres, pepadres/1.14,1.0,1.0);
   col = legs(x,y+0.04, col, pink, black, gray,1.0, kalosze,1.0);
   col = head(x*0.55+0.29,y*0.74+0.24, col, pink, pinkp, lips, black, white,0.0,0.0,0.0,mouth,3.0);
   return col;
}


vec3 daddy(float x, float y, vec3 col, vec3 pink, vec3 pinkp, vec3 lips, vec3 black, vec3 white, vec3 pepadres, vec3 pepadresp, vec3 gray, vec3 kalosze, float glass, float poz)
{

   col = legs(x,y+0.08, col, pink, black, gray, poz, kalosze, 0.0);

   col = body(x*(1.0-glass*0.2)+glass*0.1,y*(1.6-glass*0.2)-0.26+glass*0.04, col, pink, pinkp, pepadres, pepadres/1.14,1.0,1.0);
   float xtemp=x-0.25;
   float ytemp=y+0.25;
   col = head(x*0.8+0.12,y*0.8+0.18, col, pink, pinkp, lips, black, white,glass,glass,0.0,1.0,4.0);
   x=xtemp;
   y=ytemp;


   float c;
   if(glass!=0.0)
   for(float z=1.0; z>0.0; z-=0.1)
   {
      c = circleplama(x*6.4-1.87,y*6.4-3.95,0.24+(0.1*z),6.0,0.035);
      col = pepadres*(0.9+z*0.12)*(c) + (col)*(1.0-c);
      c = circleplama(x*6.4-1.1,y*6.4-4.10,0.10+(0.1*z),3.0,0.015);
      col = pepadres*(0.9+z*0.12)*(c) + (col)*(1.0-c);
   }
   return col;
}



vec3 trawa(float x, float y, vec3 col)
{
   float c;
   vec3 grass2 = vec3(84,163,84)/255.0;
   c = rect(x+0.001*sin(11010.5*y),y, -0.001, -0.01, 0.006, 0.02+0.013*rand(x));
   col = col*(1.0-c) + grass2*c;
   c = rect(x+0.001*sin(10000.0*y)+0.01,y, -0.001, -0.01, 0.006, 0.01+0.012*rand(100.0*y));
   col = col*(1.0-c) + grass2*c;
   c = rect(x+0.002*sin(10000.0*y+0.03*rand(y))+0.02,y, -0.001, -0.01, 0.002+0.01*rand(x), 0.01+0.02*rand(y));
   col = col*(1.0-c) + grass2*c;
   return col;
}


vec3 kwiatek(float x, float y, vec3 col, vec3 srodek, vec3 white)
{
   vec3 lodyga = vec3(63,137,78)/255.0;
 
   float c;
   c = rect(x,y, -0.001, -0.01, 0.006, 0.03);
   col = col*(1.0-c) + lodyga*c;
   c = circle(x-0.002,y-0.02, 0.003);
   col = col*(1.0-c) + srodek*c;
   c = circle(x-0.002,y-0.03, 0.0045);
   col = col*(1.0-c) + white*c;
   c = circle(x-0.002,y-0.01, 0.0045);
   col = col*(1.0-c) + white*c;
   c = circle(x-0.008,y-0.02, 0.0045);
   col = col*(1.0-c) + white*c;
   c = circle(x+0.004,y-0.02, 0.0045);
   col = col*(1.0-c) + white*c;
   return col;

}

float mountainlev(float x)
{
   return 0.7-0.1*(sin(x*3.0+0.3));
}


vec3 pepa(float x, float y)
{
   vec3 white = vec3(1,1,1);
   vec3 black = vec3(0,0,0);
   vec3 gray = vec3(192.0/255.0,192.0/255.0,192.0/255.0);
   vec3 pink = vec3(255.0,176.0,223.0)/255.0;
   vec3 pinkp = vec3(242.0,136.0,183.0)/255.0;
   vec3 lips = vec3(217.0,74.0,144.0)/255.0;
   vec3 pepadres = vec3(235.0,85.0,94.0)/255.0;
   vec3 pepadresp = vec3(220.0,46.0,54.0)/255.0;
   vec3 mamadres = vec3(255,143,95)/255.0;
   vec3 mamadresp = vec3(244,100,47)/255.0;
   vec3 tatadres = vec3(110,177,183)/255.0;
   vec3 tatadresp = tatadres/1.3;
   vec3 georgedres = vec3(109,152,221)/255.0;
   vec3 grass = vec3(120,199,110)/255.0;
   vec3 sky = vec3(135,185,246)/255.0;
   vec3 brown = vec3(124,118,82)/255.0;
   vec3 bbrown = vec3(104, 101, 70)/255.0;
   vec3 srodek = vec3(255,236,78)/255.0;
   vec3 yellow = vec3(255,236,8)/255.0;
   vec3 red = vec3(255,0,0)/255.0;
   vec3 tecza1 = vec3(255,46,0)/255.0;
   vec3 tecza2 = vec3(255,227,0)/255.0;
   vec3 tecza3 = vec3(0,245,0)/255.0;
   vec3 tecza4 = vec3(0,51,245)/255.0;
   vec3 tecza5 = vec3(185,57,252)/255.0;


   float c;
   x = x*1.4-0.05;
   y = y*1.4-0.02;

//   x = x *(1.00+0.05*sin(x*5));
//   y = y *(1.00+0.05*sin(y*4));

   vec3 col;

   // sky
   float t = y;
//   col = vec4(t*136.0/255.0+(1-t),t*186.0/255.0+(1-t),t*247.0/255.0+(1-t),1);


   
   if(y<mountainlev(x))
   {
      col = grass*(0.9+0.1*rand(x+y+x*y));
      float h = abs(y-mountainlev(x));
      float d = 0.015;
      if( h < d)
         col = (h/d)*grass*(0.9+0.1*rand(x+y+x*y))+(1.0-h/d)*sky;
   }
   else
   {
      col = sky;
   }

   col = kwiatek(x-0.1,y-0.05, col, srodek, white);
   col = kwiatek(x-0.8,y-0.09, col, srodek, white);
   col = kwiatek(x-1.3,y-0.59, col, srodek, srodek);
   col = kwiatek(x-0.0,y-0.49, col, srodek, white);
   col = kwiatek(x-0.3,y-0.09, col, srodek, srodek);
   col = kwiatek(x-1.2,y-0.16, col, srodek, srodek);


   col = trawa(x,y,col);
   col = trawa(x-0.45,y-0.02,col);
   col = trawa(x-1.16,y-0.65,col);
   col = trawa(x-0.86,y-0.10,col);
   col = trawa(x-1.26,y-0.05,col);


   // sun
   //c = circle(x-0.1,y-1.2,0.08);
   //col = col*(1.0-c) + yellow*0.8*c;

   // sun
   c = circleflower(x-0.36,y-1.2,0.075)+circlegrad(x-0.36,y-1.2,0.06);
   col = col*(1.0-c) + yellow*c;


   // chmurka
  

   // chmurka

   for(float g=0.0; g<20.0; g++)
   {
      c = .25*circleplama(x*0.3-0.03-0.04*rand(g),y*1.1-1.25-0.04*rand(g*g),0.025,10.0,0.002);
      col = col*(1.0-c) + white*c;
      c = .2*circleplama(x*0.6-0.23-0.04*rand(g),y*1.1-1.35-0.04*rand(g*g),0.025,10.0,0.002);
      col = col*(1.0-c) + white*c;
      c = .2*circleplama(x*0.08-0.03-0.04*rand(g),y*1.0-1.17-0.04*rand(g*g),0.025,10.0,0.002);
      col = col*(1.0-c) + white*c;

   }

   for(float g=0.0; g<6.0; g++)
   {
      c = .2*circleplama(x*0.02-0.04-0.08*rand(g),y*0.1-0.04*rand(g*g),0.025,10.0,0.002);
      col = col*(1.0-c) + grass*0.8*c;
   }

   // plama
   c = circleplama(x*0.3-0.19,y*1.4-0.4,0.19,10.0,0.004);
   col = col*(1.0-c) + brown*c;
   c = .8*circleplama(x*0.3-0.19,y*1.4-0.4,0.193,10.0,0.004);
   col = col*(1.0-c) + brown*c;

   // jeziorko
   c = circleplama(x*0.3-0.37,y*1.4-0.65,0.024,5.0,0.002);
   col = col*(1.0-c) + sky*0.87*c;
   c = .4*circleplama(x*0.3-0.37,y*1.4-0.65,0.029,5.0,0.002);
   col = col*(1.0-c) + sky*0.87*c;

   // tata
   col = daddy(x*0.75-0.16,y*0.75+0.03, col, pink, pinkp, lips, black, white, tatadres, tatadresp, bbrown, grass*1.3, 1.0, 0.0);
   float a=-0.2;

   // mama
   col = mama((1.0-x)*0.85-0.15,y*0.85+0.04, col, pink, pinkp, lips, black, white, mamadres, mamadresp, bbrown, red,1.0 );
   // pepa
// col = pepa(1.0-x*1.5+0.15,y*1.3, col, pink, pinkp, lips, black, white,pepadres, pepadresp, bbrown, yellow );  
   col = mama(1.0-x*1.5+0.15,y*1.3, col, pink, pinkp, lips, black, white,pepadres, pepadresp, bbrown, yellow,0.0 );
   // george
 //  col = george(x*2.4-1.9,y*2.3-0.278, col, pink*1.1, pinkp, lips, black, white,georgedres*0.825*(0.9+0.1*rand(x+y+x*y)), pepadresp, bbrown, 0.0, white );
   col = daddy(x*2.4-1.9,y*2.3-0.278, col, pink*1.1, pinkp, lips, black, white,georgedres*0.825*(0.9+0.1*rand(x+y+x*y)), pepadresp, bbrown, grass*1.3, 0.0, 0.0);
//   col = daddy(x*2.4-1.9,y*2.3-0.278, col, pink*1.1, pinkp, lips, black, white,georgedres*0.825*(0.9+0.1*rand(x+y+x*y)), pepadresp, bbrown, 0.0, white, 0.0, 1.0 );
   // george2.

   float xtemp=x-1.95;
   float ytemp=y-1.5;
   float a2=1.5;
   x=xtemp*cos(a2)-ytemp*sin(a2)+0.0;
   y=xtemp*sin(a2)+ytemp*cos(a2)+1.7;
//   col = george2(x*3.1-3.1,y*3.1-0.38, col, pink, pinkp, lips, black, white, grass*1.5*(0.9+0.1*rand(x+y+x*y)), pepadresp, bbrown, 1.6, sky );
   col = daddy(x*3.1-3.1,y*3.1-0.38, col, pink, pinkp, lips, black, white, grass*1.5*(0.9+0.1*rand(x+y+x*y)), pepadresp, bbrown, sky, 0.0, 1.0);
   x=xtemp+1.95;
   y=ytemp+1.5;


   //pilka
   float yy=-0.03*abs(sin(2.0*time));
   c = 1.0-circle(x*0.9-1.09+yy,y*1.9-0.255,0.06);
   col = col*(c) + (0.8*grass)*(1.0-c);

   c = 1.0-circle(x-1.25+0.06,y-0.175+yy,0.06);
   col = col*(c) + ((0.9+0.1*rand(x))*yellow)*(1.0-c);


   for(float i=1.0; i<3.0; i++)
   {
      c = circleplama(x*12.4*(0.95+0.05*rand(i))-3.9-0.5*i-3.0*(rand(i*i*i))*(y-(y*5.3-1.6))/i+rand(i)*0.4,y*5.3-1.4-rand(i)*1.2,0.1+0.15*rand(i*i*i),4.0,0.01);
      col = bbrown*0.9*(c) + (col)*(1.0-c);
   }

   for(float i=1.0; i<3.0; i++)
   {
      c = circleplama(x*12.4*(0.95+0.03*rand(i))-5.4-0.3*i+3.0*(rand(i*i))*(y-(y*5.3-1.6))/i+rand(i)*0.4,y*7.3-1.8-rand(i)*1.3,0.05+0.25*rand(i*i*i)/i,4.0,0.01);
      col = bbrown*0.9*(c) + (col)*(1.0-c);
   }


     // post process

   // cien
   c = 0.6+0.45*circledistin(x-0.55,y-0.815,0.968);
   col = col*(c) + (black)*(1.0-c);


   // krople
   col = kropla(0.82-y*1.0,x*0.53*(0.6+0.6*sin(y)),col,bbrown*0.9);
   col = kropla(0.742-y*0.6,x*0.45*(0.9-0.2*sin(y)),col,bbrown*0.9);
   col = kropla(1.092-y*1.8,x*0.43*(1.9-0.2*sin(y))-0.26,col,bbrown*0.9);
   col = kropla(1.51-y*1.98,x*0.73*(0.6+0.3*sin(5.0*y))+0.15,col,bbrown*0.9);
   col = kropla(0.78-y*0.6,x*0.73*(0.9+0.3*sin(-10.1*y))+0.23,col,bbrown*0.9);
   col = kropla(0.78-y*0.6,-0.04+x*0.73*(0.9+0.3*sin(-15.1*y))+0.23,col,bbrown*0.9);
   col = kropla(1.41-y*1.98,x*0.73*(0.9+0.3*sin(5.0*y))+0.25,col,bbrown*0.9);

   return col;

}
void main(void)
{
   vec2 p = (gl_FragCoord.xy/resolution.xy);
   vec3 col = pepa(p.x, p.y);
   gl_FragColor = vec4(col,1.0);
}
