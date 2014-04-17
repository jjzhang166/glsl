//Thematica: colorizer
#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 colorize(vec2 pos){
float r=pos.x,g=pos.y,b=pos.x+pos.y;
for(int i=0;i<20;i++){
	r +=  3.0*sin( pow(abs(sin(time/(2.0+r))),g) );
	g +=sin( g*pow(abs(sin(time/(2.0+b))),r));
	b += pow(abs(sin(time*0.1)),g);}
	vec3 col=vec3(r,g,b-r);
	return normalize(col);
}

void main( void ) {
	vec2 pos = (gl_FragCoord.xy / resolution) * 2.0 - 1.0;		
	gl_FragColor = vec4( abs( colorize(pos)), 1.0 );
}
