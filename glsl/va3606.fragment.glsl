#ifdef GL_ES
precision mediump float;
#endif

// Smooth checkerboard

uniform float time;
uniform vec2 resolution;

const float smoothFactor = 10.0;

void main( void ) 
{

	
   vec2 p = ( (gl_FragCoord.xy - resolution.xy*0.5) / min(resolution.x, resolution.y))*(2.0+10.0*abs(sin(time*2.0)));
   
   float an = time*.1;
   vec2 rotated = vec2(p.x*sin(an) + p.y*cos(an), p.y*sin(an) - p.x*cos(an));
	
   float x = (abs(sin(rotated.x))*sign(sin(rotated.x)))*smoothFactor;	
   float y = (abs(sin(rotated.y))*sign(sin(rotated.y)))*smoothFactor;	
	
   float c = clamp((x*y)+0.5, 0.0, 1.0);	

   float r = mix(0.0, 0.9, c);
   float g = mix(0.8, 0.55, c);
   float b = mix(0.9, 0.0, c);
	
   gl_FragColor = vec4(r, g, b, 1.0 );
}