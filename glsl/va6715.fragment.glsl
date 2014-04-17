#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 c(vec2 p) {
  float f = sin(p.x - time) - p.y;
  float ff = smoothstep(0.5, .7, f);
  return vec3(ff);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy )*8. -4.;
        vec3 col = c(position); 
        if ((position.y -.05 < 0.) && position.y -.02 > 0.) { col += vec3(.4,1.,0.); }
        if ((position.y -.05 < 1.) && position.y -.02 > 1.) { col += vec3(.4,1.,0.); }
        if ((position.y -.05 < 2.) && position.y -.02 > 2.) { col += vec3(.4,1.,0.); }
        if ((position.y -.05 < 3.) && position.y -.02 > 3.) { col += vec3(.4,1.,0.); }

	gl_FragColor = vec4( col, 1.0 );
}