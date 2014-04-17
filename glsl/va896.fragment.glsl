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
  c = cos(vec3(cos(c.r+r/6.0)*c.r-cos(c.g+r/5.0)*c.g,c.b/3.0*c.r-cos(r/7.0)*c.g,c.r+c.g+c.b+r));
  return dot(c*c,vec3(1.0))-1.0;
}

void main( void ) {
  vec2 c=-1.+2.0*gl_FragCoord.rg/resolution.xy;
  vec3 o,g=vec3(c.r,c.g,1)/64.;
  vec4 v;
  for(float i=1.;i<666.;i+=2.0)
    {
      vec3 vct = o+g*i;
      float scn = e(vct);
      if(scn<.4)
        {
          vec3 r=vec3(.15,0.,0.),c=r;
          c.r=scn-e(vec3(vct+r.rgg));
          c.g=scn-e(vec3(vct+r.grg));
          c.b=scn-e(vec3(vct+r.ggr));
          v+=dot(vec3(0.,0.,-1.0),c)+dot(vec3(0.0,-0.5,0.5),c);
          break;
        }
        ii=i;
    }
  gl_FragColor=v+vec4(.1+cos(r/14.)/9.,0.1,.1-cos(r/3.)/19.,1.)*(ii/44.);
}