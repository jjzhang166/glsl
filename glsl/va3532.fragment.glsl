#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 pal(float col) {
	return vec4(
		clamp(sin(col*5.2)*0.4, 0.0, 1.0),
		clamp(sin(col*3.457), 0.0, 1.0),
		col/0.1*mod(col, 0.5),
		1.0);
}

vec4 texture(vec2 pos) {
	return pal(mod(pos.x, 0.5)+mod(pos.y, 0.5));
}

void main( void ) {

       vec2 position = ( gl_FragCoord.xy / gl_FragCoord.xy);
       position.x *= resolution.x / resolution.y;

       float dist=sqrt(dot(position,position));

       vec2 pos;
       pos.x=0.0;
       pos.y=0.2/dist+time;

       gl_FragColor=texture(pos)+(1.0-dist*4.0);

}