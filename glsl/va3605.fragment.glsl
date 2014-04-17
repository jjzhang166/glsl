#ifdef GL_ES
precision mediump float;
#endif
//tigrou (ind) 2012.08.22, based on http://pouet.net/prod.php?which=59786
uniform float time;
uniform vec2 resolution;

void main( void ) 
{
   vec2 p = ( (gl_FragCoord.xy-resolution.xy/2.0) / min(resolution.x, resolution.y))*20.0;
	
   float c = abs(p.x+p.y)-abs(p.x-p.y*cos(p.x)*4.0)-atan(p.x*sin(p.x)*8.0,p.x)+sin(p.y*2.0);
   
   c = abs(sin(c))*sign(sin(c*sin(time)))+1.0;	
   if (c < 0.1) c *= sin(p.x);
   else if (c > 0.1 && c < 0.12) c = float((sin(c*0.25)+1.0));
   else c *= cos(p.y);
	   
   gl_FragColor = vec4(c * 0.9, c*0.5, c*0.2, 1.0 );

}