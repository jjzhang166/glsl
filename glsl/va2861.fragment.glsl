// My first attempt at a Mandlebrot set... 
// Set precision to 0.5 if your gfx card can handle it!
// Dave C.

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

void main(void) {
vec2 position = ( gl_FragCoord.xy / resolution.xy );	
float zoom = (mouse.y / 0.5);

float real = position.x * zoom;
float imaginary = position.y * zoom;	
float const_real = real;
float const_imaginary = imaginary;

float z2 = 0.0;

int iter_count = 0;

for(int iter = 0; (iter < 25) ; ++iter)
{
   float temp_real = real;
   
   real = (temp_real * temp_real) - (imaginary * imaginary) + const_real;
   imaginary = 2.0 * temp_real * imaginary + const_imaginary;
   z2 = real * real + imaginary * imaginary;

   iter_count = iter;

   if (z2 > 4.0) 
      break;
}

if (z2 < 4.0)
   gl_FragColor = vec4(0.0);
else	
   gl_FragColor = vec4(mix(vec3(0.0, 0.0, 0.5), vec3(1.0, 1.0, 1.0), fract(float(iter_count)*0.02)), 1.0);
}