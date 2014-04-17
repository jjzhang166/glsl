// Text II - @h3r3

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

bool rect(in vec2 pos, in vec2 upperLeft, in vec2 lowerRight) {
	return pos.x > upperLeft.x && pos.y > upperLeft.y && pos.x < lowerRight.x && pos.y < lowerRight.y;
}

bool tria(in vec2 pos, in vec2 a, in vec2 b, in vec2 c) {
	vec2 v0 = c - a, v1 = b - a, v2 = pos - a;
	float dot00 = dot(v0, v0), dot01 = dot(v0, v1), dot02 = dot(v0, v2), dot11 = dot(v1, v1), dot12 = dot(v1, v2);
	float invDenom = 1. / (dot00 * dot11 - dot01 * dot01);
	float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
	float v = (dot00 * dot12 - dot01 * dot02) * invDenom;
	return (u >= .0) && (v >= .0) && (u + v < 1.);
}

bool letterH(in vec2 pos) {
	return pos.x>.0 && pos.x<.6 && pos.y>.0 && pos.y<1.
		&& rect(pos, vec2(.0), vec2(.2,1.))
		|| rect(pos, vec2(.2,.4), vec2(.4,.6))
		|| rect(pos, vec2(.4,.0), vec2(.6,.5))
		|| tria(pos, vec2(.4,.5), vec2(.6,.5), vec2(.4,.6));
}

bool letter3(in vec2 pos) {
	return pos.x>.0 && pos.x<.6 && pos.y>.0 && pos.y<1.
		&& rect(pos, vec2(.0), vec2(.4, .2))
		|| rect(pos, vec2(.0,.8), vec2(.4, 1.))
		|| rect(pos, vec2(.2,.4), vec2(.4,.6))
		|| (pos.x <.6
		    && tria(pos, vec2(.4,.0), vec2(.4,1.), vec2(1.4,.5))
		    && !tria(pos, vec2(.6,.6), vec2(.6,.4), vec2(.5,.5)));
}

bool letterR(in vec2 pos) {
	return pos.x>.0 && pos.x<.6 && pos.y>.0 && pos.y<1.
		&& rect(pos, vec2(.0), vec2(.2, 1.))
		|| (pos.x > .2
		    && pos.x < .6
		    && tria(pos, vec2(-.2,.6), vec2(.4,.9), vec2(1.,.6))
		    && !tria(pos, vec2(.2,.6), vec2(.4,.7), vec2(.6,.6)));
}

void main()
{
	vec3 color;
	vec2 p = vec2(gl_FragCoord.x - resolution.x/2., gl_FragCoord.y - resolution.y/2.) / resolution.y;
	color.r = (1. - cos(p.x + p.y));
	color.g = color.r * .5;
	p = p * (.5 + 1.0) * 164. + .2;
	float alpha = .3;
	for (float i = .0; i < 10.; i += 1.) {
		//if (i > 8.5) { alpha = .9; }
		p.x += cos(time) * .3 + .4;
		p.y += sin(time) * .2 + .4;
		
		p.x += cos(p.y * .35 + time * 1. +i * 10.) * .14;
		p.y += cos(p.x * .35 + time * 1. +i * 20.) * .14;
		
		
		float xx = p.x; p.x = cos(time * .1) * p.y; p.y = sin(time * .2) * xx;
		
		p *= cos(time * .5) * .05 + 0.6;
		if (letterH(vec2(p.x+1.,p.y))
		    || letter3(vec2(p.x+.2,p.y))
		    || letterR(vec2(p.x-.6,p.y))
		    || letter3(vec2(p.x-1.4,p.y))) { 
			color += alpha * vec3(.5 + i *.05,1.,.5 + i *.05);
		}
	}
	gl_FragColor = vec4(mix(color, texture2D(backbuffer, gl_FragCoord.xy / resolution.xy).rgb, 0.9), 1.);
	gl_FragColor *= (abs(sin(gl_FragCoord.y * 500./ resolution.y))*.05 + .95);
}