#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float t = time;

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	if (position.x > 0.5) {
		if (position.y > 0.5) {
	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) * .2 + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;
	
	float red = 1.0;
	vec4 outs = vec4(red, color, sin(color + time / 3.0), 1.0);

//	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	gl_FragColor = outs;
} else {
	t = time * sin(sin(position.x)*time) * 0.01 - cos(time);
	position.x = sin(position.x)*sin(position.y);
	vec4 outs = vec4(sin(position.x*t), cos(position.x * t), sin(position.x*2.0)*sin(position.y*t) * 1.9*sin(position.y*t), 1.0);
	outs.r = sin(20.0*t*length(position.x - float(0.8)));
	outs.g = outs.g*t;
	outs.b = sin(29.0*t*length(position.x - float(0.5*t)));
	outs.g = 1.0-sin(t*2.0);
	gl_FragColor = outs;	
}
} else {
	if (position.y > 0.4 && position.y < 0.8) {
		float blue = sin(time);
		//blue = sin(time * sin(time*2));
		blue = sin(time);
		float color = 1.0 - blue * sin(position.x * time);
		vec4 outs = vec4(blue, color * position.y , sin(color), 1.0);
		gl_FragColor = outs;
	} else  {
//		t = time;
		vec4 outs = vec4(0.0);
		if (position.y > 0.8) {
			t = time*sin(position.x*sin(time));	
		}
		outs.r = tan(t);
		outs.g = min(sin(time), 1.0) - outs.r;
		outs.r = sin(outs.r*position.x);
		outs.g = tan(position.y*sin(time));
		gl_FragColor = outs;
	}
}
	
	gl_FragColor *= sin(t)+0.5 * sin(time*position.x);
	if (position.x *sin(time)> 0.45 && position.x*sin(time) < 0.55) {
		gl_FragColor *= 0.2;
	}

	if (position.x *cos(time)> 0.25 && position.x*cos(time) < 0.30) {
		gl_FragColor *= 0.2;
	}
	
	if (abs(position.x *cos(time))> 0.25 && abs(position.x*cos(time)) < 0.30) {
		gl_FragColor *= 0.2;
	}


}

