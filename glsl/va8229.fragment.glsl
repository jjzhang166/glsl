#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
  

vec4 bg = vec4(0.0, 0.0, 0.0, 1.0); 
vec4 line = vec4(1.0, 0.0, 0.0, 1.0);
vec2 uv;

vec3 pointcolor(vec4 off) {
   vec2 point = vec2(0.5 + sin(time * off.x) / off.y, cos(time * off.z) / off.w);
   vec3 pulse = vec3(sin(time * 6.0) + .5, sin(time * 2.0) + .5, cos(time * 7.0) + .5) * 0.2;
   float fTemp = abs(0.2 / pow(length(uv - point), 2.0) / 1060.0);
   return vec3(fTemp*(1.2+pulse.r), fTemp*(0.2+pulse.g), fTemp*(0.8+pulse.b));
}

vec3 sinewave(float f) {
   float fTemp = abs(1.0 / pow((sin(uv.x + time + (f*1.25)) / f) + uv.y, 2.0) / 760.0);
   return vec3(fTemp*0.25, fTemp*(uv.x+0.3)*0.2, fTemp*0.25*(uv.x*1.5+0.3));
}

void main(void)
{
   uv = (gl_FragCoord.xy / resolution.xy) - vec2(0.0, 0.5);
   
   vec3 color = vec3(0.0);   
   float fTemp;
   
   for(float f = 2.5; f < 4.0; f += 0.35) {
      color += sinewave(f);
   }
  
   color += pointcolor(vec4(0.3, 3.0, 0.5, 3.0));
   color += pointcolor(vec4(0.6, 3.0, 0.4, 3.0)); 
   color += pointcolor(vec4(0.2, 3.0, 0.5, 3.0));
   color += pointcolor(vec4(0.1, 3.0, 0.4, 3.0));
         
   gl_FragColor = vec4(color, 1.0);
}