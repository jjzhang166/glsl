#ifdef GL_ES
precision mediump float;
#endif
//tigrou (ind) 2012.08.22, based on http://pouet.net/prod.php?which=59786
uniform float time;
uniform vec2 resolution;

void main( void ) 
{
   vec2 p = ( (gl_FragCoord.xy-resolution.xy/2.0) / min(resolution.x, resolution.y))*20.0;
	
   float c = abs(p.x+p.y)+abs(p.x-p.y)+atan(p.y,p.x)-float(int(time*8.0)*2);
   
   c = abs(sin(c))*sign(sin(c))+1.0;	
   if (c < 0.2) c = 0.0;
   else if (c > 0.2 && c < 1.4) c = float(int((sin(c*25.0)+1.0)));
   else c = 1.0;
	   
   gl_FragColor = vec4(c * 0.7, 0.0,0.0, 1.0 );

}