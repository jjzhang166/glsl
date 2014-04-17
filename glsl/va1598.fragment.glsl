#ifdef GL_ES
precision lowp float;
#endif

// Nautilus 1k by Weyland Yutani ... http://www.pouet.net/prod.php?which=55469 ... tweaked for webgl 12-2011

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float r=time,i,ii;

float e(vec3 c)
{
  c = cos(vec3(cos(c.r+r/1.0)*c.r-cos(c.g+r/3.0)*c.g,c.b/0.5*c.r-cos(r/3.0)*c.g,c.r+c.g+c.b+r));
  return dot(c/(vec3(0.25,0.15,0.6)),vec3(0.1))-1.0*c.y*0.1;
}

void main( void ) {
  vec2 c=-2.+4.0*gl_FragCoord.rg/resolution.xy;
  vec3 o,g=vec3(c.r,c.g,1)/64.;
  vec4 v;
  for(float i=1.;i<666.;i+=1.0)
    {
      vec3 vct = o+g*i;
      float scn = e(vct)*0.66;
      if(scn<.4)
        {
          vec3 r=vec3(.5,0.08,0.3),c=r;
          c.r=scn-e(vec3(vct+r.rgg));
          c.g=scn-e(vec3(vct+r.grg));
          c.b=scn-e(vec3(vct+r.ggr));
          v+=dot(vec3(0.,0.,-1.0),c)+dot(vec3(0.0,-0.25,0.125),c);
          break;
        }
        ii=i*0.66;
    }
  gl_FragColor=v+vec4(.1+cos(r/10.)/9.,0.1,.1-cos(r/1.)/10.,1.)*(ii/66.);
}