#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

#define pi 3.14

void main() 
{
      vec2 uv = gl_FragCoord.xy / resolution.xy;
      vec2  o = uv - .5;
      float p = length(o);
      float t = time * 99999.;
      float r = atan(o.x, o.y);
      
      float rot = fract(t-o.x)+fract(t+o.y);
      
      float s = fract(atan(o.x, o.y)*rot);
    
   
    
      gl_FragColor = vec4(1.) * s;
}//a nifty test of your drivers - sphinx