#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.141592653

float hex(vec2 p, float r2) 
{
   p.x *= 1.16; //no product, simple number, shortened - Chaeris
   p.y += mod(floor(p.x), 4.0)*1.5;
   p = abs((mod(p, 1.00) - 0.50));
   return abs(max(p.x*1.5 + p.y, p.y*2.0) - r2);
}

void main(void)
{
   float spinTime = 0.35;
   float spinTimeMultiply = 0.02;

   vec2 position = 100.0 * ((gl_FragCoord.xy) / resolution.y);

   float r = length(position);
   float a = atan(position.y, position.x);
   float d = r - a;// + PI;
   float n = PI * float(int(d / PI));
   float k = a + n;

   spinTime = (spinTimeMultiply * time);
   float rand = sin(PI * floor((0.010) * k * n + spinTime));
   vec4 spiral =  vec4(fract(time*rand*vec3(1.0)), 1.0).arra;

   vec2 pos = 800.0 * (gl_FragCoord.xy / resolution.y);
   pos.x    += 15.0 * time;
   vec2  p   = pos*0.02; // Removed the divide - Timmons
   float r1  = 0.05; //Simplified number2 - Chaeris
   float r2  = 0.3;
   vec4 hexgrid = vec4(smoothstep(.0, r1, hex(p,1.0-r2)));
	
   vec4 hi = vec4(0.0);
   if (pos.y >= 550.0 && pos.y <= 700.0) hi = vec4(1.0)*position.x*0.006;

   if (spiral.g <= 0.5) hexgrid = mix(spiral, hexgrid, 0.2);
   gl_FragColor = (spiral*hexgrid)-position.x*0.007+hi;
}