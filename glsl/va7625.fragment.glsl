#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

    vec2 xy = -1.0 + 2.0*gl_FragCoord.xy / resolution.xy;
	
    vec2 uv = xy*0.5+0.5;
    vec3 col = vec3(1);
    col *= 0.7 + 0.3*pow(16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y),0.4);
    gl_FragColor=vec4(col,1.0);
}