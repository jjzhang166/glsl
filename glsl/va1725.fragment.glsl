#ifdef GL_ES
precision mediump float;
#endif


// Nautilus 1k ... by Weyland Yutani
// http://www.pouet.net/prod.php?which=55469
	
precision lowp float;
uniform vec2 resolution;
uniform float time;

float r=time/2.0,i,ii;

float e(vec3 c)
{
 c=cos(vec3(cos(c.r+r/8.)*c.r-cos(c.g+r/9.)*c.g,c.b/3.*c.r-cos(r/7.)*c.g,c.r+c.g+c.b/1.25+r));
 return dot(c*c,vec3(1.))-1.0;
}
void main()
{
 vec2 c=-1.+2.*gl_FragCoord.rg/resolution.xy;
 vec3 o=vec3(c.r,c.g+cos(r/2.)/30.,0),g=vec3(c.r+cos(r)/30.,c.g,1)/64.;
 vec4 v=vec4(0.0,0.0,0.0,1.0);
 for(float i=1.;i<666.;i+=2.)
   {
     if(e(o+g*i)<.4)
       {
         vec3 r=vec3(.1,0,0),c=r;
         c.r=e(o+g*i)-e(vec3(o+g*i+r.rgg));
         c.g=e(o+g*i)-e(vec3(o+g*i+r.grg));
         c.b=e(o+g*i)-e(vec3(o+g*i+r.ggr));
         v+=dot(vec3(0,0,-.5),c)+dot(vec3(0,-.5,.5),c);
         break;
       }
       ii=i;
   }
 gl_FragColor=v+vec4(.1+cos(r/14.)/8.,.1,.1-cos(r/3.)/19.,1.)*(ii/41.);
}



