#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 rotate(vec2 p, float ang){
    float c = cos(ang), s = sin(ang);
    return vec2(p.y * c - p.x * s, p.y * s + p.x * c);
}

vec2 zoom(vec2 p, float factor){
    return vec2(p.x * factor, p.y * factor);
}
void main( void ) {

	vec2 position = gl_FragCoord.xy/resolution.y-vec2((resolution.x/resolution.y)/2.0,0.5);
	position=rotate(position,sin(time+length(position))*4.0);
	position=zoom(position,sin(time*0.2)*2.0+2.1);
	float value = sin(1.0-distance(position,vec2(0,0))*32.0+time*8.0)*0.5+0.5;
	position.y+=sin(position.x*4.0+time)*0.2;
	position.x+=cos(time/1.238374);
	float value2=sin(1.0-length(position)*32.0+time*8.0)*0.5+0.5;
	position.x+=sin(position.y*5.0+time)*0.2;
	position.y+=sin(time/1.6756);
	float value3=sin(1.0-length(position)*32.0+time*8.0)*0.5+0.5;
	value;
	gl_FragColor = vec4(value3,value2-value3,value-length(value3+value2), 1.0 );

}