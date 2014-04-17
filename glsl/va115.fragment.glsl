// forked from http://glsl.heroku.com/37/4 by @Flexi23

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

       vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;

       float rnd1 = mod(fract(sin(dot(position + time, vec2(14.9898,78.233))) * 43758.5453), 1.0);
       float rnd2 = mod(fract(sin(dot(position+vec2(rnd1), vec2(14.9898,78.233))) * 43758.5453), 1.0);
       float rnd3 = mod(fract(sin(dot(position+vec2(rnd2), vec2(14.9898,78.233))) * 43758.5453), 1.0);
       float rnd4 = mod(fract(sin(dot(position+vec2(rnd3), vec2(14.9898,78.233))) * 43758.5453), 1.0);

	gl_FragColor = vec4(0.);

	gl_FragColor = texture2D(backbuffer, position + pixel*(vec2(rnd3, rnd4)-0.5)*2.) - 0.001 + (vec4(rnd1,rnd2,rnd3,rnd4)-0.5)*0.02; // error diffusion dither
	gl_FragColor += clamp(1.- length(position-mouse)*32., 0., 1.);

}