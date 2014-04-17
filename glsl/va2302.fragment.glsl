// Psycoflowers III - @h3r3

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float getVal(in vec2 position) {
	float u = sqrt(dot(position, position));
	float v = atan(position.y, position.x);
	float t = time + 1.0 / u;
	float val = sin(0.5 * (time * 3.0 + 10.0 * v) );
	return max(-0.5,val);
}

float getMix(in vec2 position, float n) {
	float val1 = getVal(position + vec2(cos(time * 0.35 + n + n), sin(time * 0.23 + n + 10.0)) * 0.8);
	float val2 = getVal(position + vec2(sin(time * 0.21 + n * n), cos(time * 0.36 + n + 4.2)) * 0.8);
	return (val1 * val2 + val1 + val2) * 0.6;
}

vec3 colorMix(in vec2 position, in vec3 color, in float n) {
	float val = getMix(position, n);
	return color * val + (1.0 - val) * vec3(0.1, 0.05, 0.1);
}

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
	return rect(pos, vec2(.0), vec2(.2, 1.))
		|| rect(pos, vec2(.2,.4), vec2(.4,.6))
		|| rect(pos, vec2(.4,.0), vec2(.6,.5))
		|| tria(pos, vec2(.4,.5), vec2(.6,.5), vec2(.4,.6));
}

bool letter3(in vec2 pos) {
	return rect(pos, vec2(.0), vec2(.4, .2))
		|| rect(pos, vec2(.0,.8), vec2(.4, 1.))			
		|| rect(pos, vec2(.2,.4), vec2(.4,.6))
		|| (pos.x <.6
		    && tria(pos, vec2(.4,.0), vec2(.4,1.), vec2(1.4,.5))
		    && !tria(pos, vec2(.6,.6), vec2(.6,.4), vec2(.5,.5)));
}

bool letterR(in vec2 pos) {
	return rect(pos, vec2(.0), vec2(.2, 1.))
		|| (pos.x > .2
		    && pos.x < .6
		    && tria(pos, vec2(-.2,.6), vec2(.4,.9), vec2(1.,.6))
		    && !tria(pos, vec2(.2,.6), vec2(.4,.7), vec2(.6,.6)));
}

void main()
{
	vec2 position = -1.0 + 2.0 * (gl_FragCoord.xy / resolution.xy);
	position.x *= resolution.x / resolution.y;
	vec3 color = vec3(0.0);
	for (int i = 0; i < 4; i++) {
		float fi = float(i * i + i);
		//color += colorMix(position, vec3(sin(fi * 0.9), sin(fi * 0.9) * 0.4, sin(fi * 0.7 + 2.0)), fi);
	}
	position = gl_FragCoord.xy / resolution.xy;
	
	vec2 centerpos = vec2(0.5 + cos(time) * 0.3, 0.5 + sin(time * 0.77) * 0.3);
	float d = (1.0 - distance(position, centerpos)) * 0.04;
	
	centerpos -= position;
	//glowy affect
	for (float j = 0.0; j < 0.18; j+= 0.01) {
		color = mix(color, texture2D(backbuffer, position + centerpos * j).rgb, 0.2 - j); // 0.2
	}
	color += d * d + d ;
	
	float ztime = time * .2;
	vec2 p = vec2(gl_FragCoord.x - resolution.x/2., gl_FragCoord.y - resolution.y/2.) / resolution.y;
	p = p * (cos(ztime) + 1.0) * 3. + .5;
	
	float alpha = (sin(ztime) * .6);
	if (alpha <0.0 
	    && (letterH(vec2(p.x+1.,p.y))
		|| letter3(vec2(p.x+.2,p.y))
		|| letterR(vec2(p.x-.6,p.y))
		|| letter3(vec2(p.x-1.4,p.y))
		)
	   ) {
		color = mix(color, vec3(1.0), alpha * alpha);
	}
	gl_FragColor = vec4(abs(color), 1.0);
}