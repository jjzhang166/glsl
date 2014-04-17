// by @FUCKNG_s

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

bool is_onscreen(vec2 uv){
	return (uv.x < 1.) && (uv.x > 0.) && (uv.y < 1.) && (uv.y > 0.);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
	float aspect = resolution.x/resolution.y;

	// Julia fractal in .y

	vec2 c = vec2(-0.18, -0.18) + (mouse.yx-0.5)*vec2(0.02,-0.055);
	vec2 tuning =  vec2(1.7) - (mouse.y-0.5)*0.03;
	vec2 complexSquaredPlusC; // One steps towards the Julia Attractor
	vec2 uv = (position - vec2(0.5))*tuning;
	complexSquaredPlusC.x = (uv.x * uv.x - uv.y * uv.y + c.x + 0.5);
	complexSquaredPlusC.y = (2. * uv.x * uv.y + c.y + 0.5);
	
	float old = texture2D(backbuffer, complexSquaredPlusC).y;
	if(is_onscreen(complexSquaredPlusC)){
		gl_FragColor.y = old + 0.008;
	}else{
		// return border color
		gl_FragColor.y = 0.;
	}

	// using the gradients from .y as displacement vector for the spotlight in .x
	vec2 pixelSize = 0.75/resolution;
	float dx = texture2D(backbuffer, position + vec2(1.,0.)*pixelSize).y - texture2D(backbuffer, position - vec2(1.,0.)*pixelSize).y;
	float dy = texture2D(backbuffer, position + vec2(0.,1.)*pixelSize).y - texture2D(backbuffer, position - vec2(0.,1.)*pixelSize).y;

	float d = length(( mouse - position + vec2(dx,dy)*8.) * vec2( aspect, 1.0 ));
	float light = clamp( 1.-d,0.,1.);
	gl_FragColor.x = pow(light,4.);
	gl_FragColor.z = 0.;
	gl_FragColor.a = 1.;

	// using the diff in .y as input in .z
	gl_FragColor.z = abs(old-texture2D(backbuffer, position).y)*1.; // diffs are magical
	vec2 zoomin = mouse + (position-mouse)*0.99;
	gl_FragColor.z = texture2D(backbuffer, zoomin).z - 0.04 + gl_FragColor.z;
}