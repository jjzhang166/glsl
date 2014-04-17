#ifdef GL_ES

precision mediump float;

#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float random(float a,float b) {
    return fract(sin(dot(vec2(a,b) ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	float aspect = resolution.x / resolution.y;
	pos.x *= aspect;   

	vec3 color = vec3(1.0, 1.0, 1.0);

	color.r *= mod(pos.x*sin(pos.y), 0.05)*8.0;
	color.g *= mod(pos.y*cos(pos.x), 0.05)*8.0;
	color.b *= mod(pos.x*pos.y*tan(pos.x*pos.y), 0.05)*8.0;
	
	
	color /= clamp(distance(vec2(sin(time*1.5)+1.,cos(time)),pos)+random(pos.x,pos.y)/10., 0.1, 1.0);
	color /= clamp(distance(vec2(sin(-time)/1.+1.,cos(-time*1.5)/2.+0.5),pos)+random(pos.x,pos.y)/10., 0.1, 1.0);

	gl_FragColor = vec4(color, 0);

}