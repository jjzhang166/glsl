#ifdef GL_ES
precision mediump float;
#endif

//testing chebychev (not intended as sin replacement)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sinApprox(const float x)
{
	// x in [-1,1]
	// Chebyshev approximation
	
	//low quality
	return 1.1102230246251564e-16
	+ x * ( 0.9999939274655865
	+ x * ( -1.4062824978585316e-15
	));
	
	/*
	//high quality
	return 1.1102230246251564e-16
	+ x * ( 0.9999939274655865
	+ x * ( -1.4062824978585316e-15
	+ x * ( -0.16655727609649598
	+ x * ( 1.6283271027835629e-15
	+ x * ( 0.008040321792918359)))));
	*/
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	vec2 p = uv;
	p.x = fract(p.x * 2.);
	
	//left sin, right approx
	if(uv.x < .5){
		p = sin(p);
	}else{
		p = vec2(sinApprox(p.x), sinApprox(p.y));
	}
	
	//error
	if (fract(time * .25) > .5){
		vec2 d = uv;
		d = vec2(abs(sin(d) - vec2(sinApprox(d.x), sinApprox(d.y))));
		
		p = d * 2.;   //low quality error creeps in at 2
		//p = d * 99999.; //high quality error - impressive
	}
			
	gl_FragColor = vec4(p, 0., 0.);
}

//sphinx
