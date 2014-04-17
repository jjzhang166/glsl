#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
void main( void ) {
	vec2 co = gl_FragCoord.xy / 5.0;
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec3 col = vec3(0.0,1.0,0.0); 
	col -=  vec3(0.0,step(0.2,(mod(position.y,0.4))*(step(1.0,mod(step(1.0,mod(co.y,2.0))+co.x,2.0))  ))*0.5,0.0);
		//vec3(0.0,step(0.2,mod(co.y,0.4))*step(0.002,mod(position.y,0.004))*step(0.002,mod(position.x,0.004)),0.0);
	//col += vec3(0.0,step(0.002,mod(position.y,0.004))*0.4,0.0);
	gl_FragColor = vec4( col, 1.0 );

}