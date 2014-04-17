// by rotwang
//oh rly?
// yes, I am putting some clear written snippets here for beginners
// do you have a problem with helping people?
// I'am tagging my snippets, so I can find and approve them
// Do you have a problem with this?
// Just stay in your kindergarten
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;


void main( void ) {
   
	vec2 unipos = gl_FragCoord.xy / resolution;
	vec2 pos = unipos *2.0-1.0;
	vec2 apos = abs(pos);
	
	float xdiv = 4.0;
	float ydiv = 2.0;
	float a = mod(unipos.x,1.0/xdiv)*xdiv;
	float b = mod(unipos.y,1.0/ydiv)*ydiv;
	
	float c = smoothstep(a*2.5, a*0.1 , b*2.0);
	vec3 clr = vec3(pow(c*a,b));
    gl_FragColor = vec4(clr, 1.0);
}