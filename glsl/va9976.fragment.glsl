#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Runner - by David Hoskins 2013
// Shadertoy address - https://www.shadertoy.com/view/MdsGRS

// ====--->  MOUSE X and stop for SPEED change!

float timeT;
float backTime;
float forTime;
float runnerHeight;
float runCycle;
float speed;

//----------------------------------------------------------------------------
float Box(vec2 p, vec2 b)
{
	return length(max(abs(p)-b,0.0));
}

//----------------------------------------------------------------------------
vec2 Segment( vec2 a, vec2 b, vec2 p )
{
	vec2 pa = p - a;
	vec2 ba = b - a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	return vec2( length( pa - ba*h ), h );
}

//----------------------------------------------------------------------------
float Windows(vec2 p)
{
	vec2 st = p+vec2(forTime, 0.0);
	st.x *= .8;
	vec2 win1 = vec2(st.x, st.y - .6);
	
	// One pane is for both sections, so only need 3...
	win1.x = mod(st.x+.03, 1.0)-.5;
	float d = Box(win1, vec2(.05, .26));
	
	win1.x = mod(st.x+.16, 2.0)-.5;
	d = min(d, Box(win1, vec2(.05, .26)));
	
	win1.x = mod(st.x+.85, 2.0)-.5;
	d = min(d, Box(win1, vec2(.1, .26)));
	
	return d;
}

//----------------------------------------------------------------------------
float Head( vec2 p, float s )
{
	p.y *= .85;
	return length(p)-s;
}

//----------------------------------------------------------------------------
vec2 Rotate(vec2 pos, vec2 piv, float ang)
{
	mat2 m = mat2(cos(ang), sin(ang), -sin(ang), cos(ang));
	pos = (m * (pos-piv))+piv;
	return pos;
}

//----------------------------------------------------------------------------
float Smin( float a, float b )
{
    float k = 0.02;
	float h = clamp( 0.5 + 0.5*(b-a)/k, 0.0, 1.0 );
	return mix( b, a, h ) - k*h*(1.0-h);
}
	
//----------------------------------------------------------------------------
vec2 Running( vec2 p)
{
	// Oh the horror! - of magic numbers. ;)
	float material = 0.0;
	float d;
	float ang = -speed*.2-.2;
	mat2 leanM = mat2(cos(ang), sin(ang), -sin(ang), cos(ang));
	runnerHeight = (sin(runCycle-.27)*.15);
	runnerHeight= pow(runnerHeight,1.3)*.8-.92+ang*.18;
	p += vec2(-speed*.4, runnerHeight);
	p *= leanM;
	float headX = sin(runCycle*.25)*.025;
	d = Head(p-vec2(.44+headX, -0.02-headX*.5), .06);
	
	float arm1 = sin(runCycle)*.6*(speed*.2+1.0);
	float leg1 = sin(runCycle)*.7*(speed*.05+.5);
	
	// Neck...
	vec2 h = Segment( vec2(0.4,-0.1-0.01-headX*.5), vec2(0.42+headX,-.04), p );
	float d2 = h.x - 0.03 + h.y*0.005;
	d = Smin(d, d2 );
	// Body...
	h = Segment( vec2(0.4,-0.17), vec2(0.4,-.37), p );
	d2 = h.x - 0.065 + h.y*0.03;
	d = Smin(d, d2 );
	
	// Upper arm...
	vec2 elbow = Rotate(vec2(0.4,-.3), vec2(.4,-0.14), arm1);
	h = Segment(vec2(0.4,-0.14),  elbow, p );
	d2 = h.x - 0.04 + h.y*0.01;
	d = min(d, d2 );
	// Lower arm...
	vec2 wrist = Rotate(elbow+vec2(.13, -.02), elbow, arm1*1.5-.3);
	h = Segment(elbow,  wrist, p );
	d2 = h.x - 0.03 + h.y*0.01;
	d = min(d, d2 );
	// Hand...
	vec2 hand = Rotate(wrist+vec2(.005, -0.0), wrist, arm1*1.5-.3);
	h = Segment(wrist,  hand, p );
	d2 = h.x - 0.03 + h.y*0.001;
	d = min(d, d2 );
	
	// Upper leg...
	vec2 knee = Rotate(vec2(0.4,-.55), vec2(.4,-0.35), -leg1+.5);
	h = Segment(vec2(0.4,-.35), knee, p );
	d2 = h.x - 0.05 + h.y*0.015;
	d = Smin(d, d2 );
	
	// Lower leg...
	vec2 rotFoot = Rotate(knee+vec2(.0, -.22), knee, -(-leg1*.3+1.6));
	rotFoot = Rotate(rotFoot, knee, smoothstep(-.2, .2, -(leg1)*.15)*5.2-1.2);
	h = Segment(knee, rotFoot , p );
	d2 = h.x - 0.03+ h.y*0.008;
	d = Smin(d, d2 );
	
	// Foot...
	vec2 toes = Rotate(rotFoot+vec2(.09, 0.0), rotFoot, smoothstep(-.1, .15, -leg1*.2)*2.4-1.7-leg1);
	h = Segment(rotFoot, toes, p );
	d2 = h.x - 0.018 + h.y*0.005;
	d = Smin(d, d2 );
	
	if (d > 0.005)
	{
		// Do shadowed back limbs if others haven't been hit...
		// Upper arm 2...
		elbow = Rotate(vec2(0.4,-.3), vec2(.4,-0.14), -arm1);
		h = Segment(vec2(0.4,-0.14), elbow, p );
		d2 = h.x - 0.04 + h.y*0.01;
		d = min(d, d2 );
		// Lower arm 2...
		wrist = Rotate(elbow+vec2(.13, -.01), elbow, -arm1*1.5+.1);
		h = Segment(elbow,  wrist, p );
		d2 = h.x - 0.03 + h.y*0.01;
		d = min(d, d2 );
		// Hand...
		vec2 hand = Rotate(wrist+vec2(.005, -0.0), wrist, -arm1*1.5-.3);
		h = Segment(wrist,  hand, p );
		d2 = h.x - 0.03 + h.y*0.001;
		d = min(d, d2 );
		// Upper leg...
		knee = Rotate(vec2(0.4,-.55), vec2(.4,-0.35), leg1+.5);
		h = Segment(vec2(0.4,-.35), knee, p );
		d2 = h.x - 0.05 + h.y*0.02;
		d = min(d, d2 );
		// Lower leg...
		rotFoot = Rotate(knee+vec2(.0, -.22), knee, -(leg1*.3+1.6));
		rotFoot = Rotate(rotFoot, knee, smoothstep(-.2, .2, leg1*.15)*5.2-1.2);
		h = Segment(knee, rotFoot, p );
		d2 = h.x - 0.03+ h.y*0.008;
		d = Smin(d, d2 );
	
		// Foot...
		toes = Rotate(rotFoot+vec2(.09, 0.0), rotFoot, smoothstep(-.1, .15, leg1*.2)*2.4-1.7+leg1);
		h = Segment(rotFoot, toes, p );
		d2 = h.x - 0.018 + h.y*0.005;
		d = Smin(d, d2 );
		material = 2.0;
	}

	return vec2(d, material);
}

//----------------------------------------------------------------------------
void main(void)
{
	timeT = time*1.4+38.5;
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv.x *= resolution.x/resolution.y;
	vec3 col;
	speed = (mouse.x)*2.0+.8;
	runCycle = timeT*7.0*speed;
	backTime = timeT * .6 *speed;
	forTime = timeT * speed *1.7;
	
	float winLight = mod((forTime+uv.x)*1.6, 2.0);
	if (winLight > 1.0) winLight = 2.0-winLight;
	winLight = pow(winLight, 2.0)+.05;
	
	float w = Windows(uv);
	if (w > 0.0)
	{
		col = vec3(0.0);
		// Do stripes and light fades...
		if (uv.y > .13)
			col = mix(col, vec3(.05)*winLight, sin(smoothstep(0.0, .01, mod(uv.x+forTime, .07)) * 3.14159) );
		else
		if (uv.y > .1)
			col = vec3(.01*winLight);
			
		col = mix(vec3(0.3), col, smoothstep(0.0, .22, sqrt(w)));
	}else
	{
		vec2 st = uv+vec2(backTime, 0.0);
		st = vec2(st.x * .04, 1.0 - st.y);
		float background = .8;//dot(texture2D(iChannel0, st).xyz, vec3(0.2126, 0.7152, 0.0722))*.8;
		col = vec3(background);
	}
	
	vec2 res = Running(uv);
	if (res.x < 0.005)
	{
		if (res.y != 0.0) winLight*=.6;
		col = vec3(winLight);
		col = mix(col, vec3(0.0), smoothstep(0.0, .005, res.x) );
	}
	col = sqrt(col);
	gl_FragColor = vec4(col,1.0);
}

//----------------------------------------------------------------------------}