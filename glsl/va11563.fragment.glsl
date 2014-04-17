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
      float t = 3.14;
      float r = atan(o.x, o.y);
      
      float rot = fract(t*o.x)+fract(t/o.y);
      
      float s = fract(p - r * rot + time);
    
      gl_FragColor = vec4(9999.) * s * s;
}//etc