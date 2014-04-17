#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool near(float i, float t, float e){
	return i > t-e && i < t+e;
}
float nearf(float i, float t, float ea){
	
	if(i < t+ea && i > t){
		return 1.0 - (i-t)/(ea);
	}else if(i > t-ea && i <= t){
		return (i-(t-ea))/(ea);
		
		return 0.0;
	}
	return 0.0;
}


void main( void ) {
	float f = 0.0;
	vec2 position = ( gl_FragCoord.xy );
	vec2 mousepos = mouse*resolution;
	
	float line_thick = 1.0;//abs( sin(time) * 5.2);//1.0;
	float half_line_thick = 0.5;
	float amp = resolution.y * 0.120;
	float minGlow = 10.0;
	//float time = 1.30;

	float o1 = (
		sin( position.x *-0.005 + time*2.5) * 0.5 
		+ cos(position.x * -0.008 + time*2.1) * 0.5
	) * amp;
	
	
	float o2 = (
		sin( position.x *-0.0068 + time*3.0) * 0.5 
		+ cos(position.x * -0.005 + time*2.3) * 0.5
	) * amp * 0.7;
	
	
	float o3 = (
		sin( position.x *-0.008 + time*2.0) * 0.5 
		+ cos(position.x * -0.003 + time*1.7) * 0.5
	) * amp;
	
	float o4 = (
		sin( position.x *-0.005 + time*3.4) * 0.5 
		+ cos(position.x * -0.0063 + time*2.7) * 0.5
	) * amp;
	
	float o5 = (
		sin( position.x *-0.0038 + time*2.7) * 0.5 
		+ cos(position.x * -0.003 + time*3.7) * 0.5
	) * amp;
	
	float o6 = (
		sin( position.x *-0.009 + time*2.0) * 0.5 
		+ cos(position.x * -0.004 + time*3.7) * 0.5
	) * amp * 0.85;
	
	float o7 = (
		sin( position.x *-0.005 + time*1.4) * 0.5 
		+ cos(position.x * -0.007 + time*3.7) * 0.5
	) * amp;
	
	float o8 = (
		sin( position.x *-0.008 + time*2.0) * 0.5 
		+ cos(position.x * -0.003 + time*1.7) * 0.5
	) * amp * 0.6;
	
	float o9 = (
		sin( position.x *-0.003 + time*2.5) * 0.5 
		+ cos(position.x * -0.0063 + time*1.7) * 0.5
	) * amp * 0.6;
	
	float o10 = (
		sin( position.x *-0.0058 + time*2.0) * 0.5 
		+ cos(position.x * -0.0023 + time*1.7) * 0.5
	) * amp;
	
	float o11 = (
		sin( position.x *-0.007 + time*2.0) * 0.5 
		+ cos(position.x * -0.0043 + time*2.7) * 0.5
	) * amp;
	
	
	
	

	
	float o1_1 = o1;
	
	float o2_1 = o2;
	float o3_1 = o3;
	//*
	float o4_1 = o4;
	float o5_1 = o5;
	float o6_1 = o6;
	float o7_1 = o7;
	float o8_1 = o8;
	float o9_1 = o9;
	float o10_1 = o10;
	float o11_1 = o11;
	//*/
	float aoe = 100.0;
	
	//o1
	if(mousepos.x > position.x && aoe - (mousepos.x-position.x) > 0.0){
		f = (aoe -(mousepos.x-position.x)) / aoe;
		f += smoothstep(0.0,1.0,f);
		o1_1 = o1 + sin(position.x *-0.18 + time*25.0) * f * amp * mouse.y;	
	}else if(mousepos.x < position.x && aoe - (position.x-mousepos.x) > 0.0){
		 f = (aoe - (position.x-mousepos.x))  / aoe;
		f += smoothstep(0.0,1.0,f);
		o1_1 = o1 + sin(position.x *-0.18 + time*25.0) * f * amp * mouse.y;	
	}
	
	
	//o2
	if(mousepos.x > position.x && aoe - (mousepos.x-position.x) > 0.0){
		 f = (aoe -(mousepos.x-position.x)) / aoe;
		f = smoothstep(0.0,1.0,f);
		o2_1 = o2 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}else if(mousepos.x < position.x && aoe - (position.x-mousepos.x) > 0.0){
		 f = (aoe - (position.x-mousepos.x))  / aoe;
		f = smoothstep(0.0,1.0,f);
		o2_1 = o2 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}
	
	//o3
	if(mousepos.x > position.x && aoe - (mousepos.x-position.x) > 0.0){
		 f = (aoe -(mousepos.x-position.x)) / aoe;
		f = smoothstep(0.0,1.0,f);
		o3_1 = o3 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}else if(mousepos.x < position.x && aoe - (position.x-mousepos.x) > 0.0){
		 f = (aoe - (position.x-mousepos.x))  / aoe;
		f = smoothstep(0.0,1.0,f);
		o3_1 = o3 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}
	
	
	//o4
	if(mousepos.x > position.x && aoe - (mousepos.x-position.x) > 0.0){
		 f = (aoe -(mousepos.x-position.x)) / aoe;
		f = smoothstep(0.0,1.0,f);
		o4_1 = o4 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}else if(mousepos.x < position.x && aoe - (position.x-mousepos.x) > 0.0){
		 f = (aoe - (position.x-mousepos.x))  / aoe;
		f = smoothstep(0.0,1.0,f);
		o4_1 = o4 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}
	
	//o5
	if(mousepos.x > position.x && aoe - (mousepos.x-position.x) > 0.0){
		 f = (aoe -(mousepos.x-position.x)) / aoe;
		f = smoothstep(0.0,1.0,f);
		o5_1 = o5 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}else if(mousepos.x < position.x && aoe - (position.x-mousepos.x) > 0.0){
		 f = (aoe - (position.x-mousepos.x))  / aoe;
		f = smoothstep(0.0,1.0,f);
		o5_1 = o5 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}
	
	
	//o6
	if(mousepos.x > position.x && aoe - (mousepos.x-position.x) > 0.0){
		 f = (aoe -(mousepos.x-position.x)) / aoe;
		f = smoothstep(0.0,1.0,f);
		o6_1 = o6 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}else if(mousepos.x < position.x && aoe - (position.x-mousepos.x) > 0.0){
		 f = (aoe - (position.x-mousepos.x))  / aoe;
		f = smoothstep(0.0,1.0,f);
		o6_1 = o6 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}
	
	
	//o7
	if(mousepos.x > position.x && aoe - (mousepos.x-position.x) > 0.0){
		 f = (aoe -(mousepos.x-position.x)) / aoe;
		f = smoothstep(0.0,1.0,f);
		o7_1 = o7 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}else if(mousepos.x < position.x && aoe - (position.x-mousepos.x) > 0.0){
		 f = (aoe - (position.x-mousepos.x))  / aoe;
		f = smoothstep(0.0,1.0,f);
		o7_1 = o7 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}
	
	
	//o8
	if(mousepos.x > position.x && aoe - (mousepos.x-position.x) > 0.0){
		 f = (aoe -(mousepos.x-position.x)) / aoe;
		f = smoothstep(0.0,1.0,f);
		o8_1 = o8 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}else if(mousepos.x < position.x && aoe - (position.x-mousepos.x) > 0.0){
		 f = (aoe - (position.x-mousepos.x))  / aoe;
		f = smoothstep(0.0,1.0,f);
		o8_1 = o8 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}
	
	
	//o9
	if(mousepos.x > position.x && aoe - (mousepos.x-position.x) > 0.0){
		 f = (aoe -(mousepos.x-position.x)) / aoe;
		f = smoothstep(0.0,1.0,f);
		o9_1 = o9 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}else if(mousepos.x < position.x && aoe - (position.x-mousepos.x) > 0.0){
		 f = (aoe - (position.x-mousepos.x))  / aoe;
		f = smoothstep(0.0,1.0,f);
		o9_1 = o9 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}
	
	
	//o10
	if(mousepos.x > position.x && aoe - (mousepos.x-position.x) > 0.0){
		 f = (aoe -(mousepos.x-position.x)) / aoe;
		f = smoothstep(0.0,1.0,f);
		o10_1 = o10 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}else if(mousepos.x < position.x && aoe - (position.x-mousepos.x) > 0.0){
		 f = (aoe - (position.x-mousepos.x))  / aoe;
		f = smoothstep(0.0,1.0,f);
		o10_1 = o10 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}
	
	
	//o11
	if(mousepos.x > position.x && aoe - (mousepos.x-position.x) > 0.0){
		 f = (aoe -(mousepos.x-position.x)) / aoe;
		f = smoothstep(0.0,1.0,f);
		o11_1 = o11 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}else if(mousepos.x < position.x && aoe - (position.x-mousepos.x) > 0.0){
		 f = (aoe - (position.x-mousepos.x))  / aoe;
		f = smoothstep(0.0,1.0,f);
		o11_1 = o11 + sin(position.x *-0.08 + time*23.0) * f * amp * mouse.y;	
	}
	
	vec4 c1  = vec4(0.0,0.2,0.8,1.0);
	vec4 c2  = vec4(0.0,0.2,0.5,1.0);
	vec4 c3  = vec4(0.0,0.5,0.4,1.0);
	vec4 c4  = vec4(0.0,0.0,0.9,1.0);
	vec4 c5  = vec4(0.0,0.6,0.5,1.0);
	vec4 c6  = vec4(0.0,0.4,1.0,1.0);
	vec4 c7  = vec4(0.0,0.2,0.7,1.0);
	vec4 c8  = vec4(0.0,0.3,0.5,1.0);
	vec4 c9  = vec4(0.0,0.8,0.6,1.0);
	vec4 c10 = vec4(0.0,0.0,0.5,1.0);
	vec4 c11 = vec4(0.0,0.5,0.7,1.0);
	
	vec4 o  = vec4(0.0,0.0,0.0,0.0);
	float glow = 0.0;
	float modulator = 0.0;
	
	for(float j = 0.0; j < 1.0; j++){
		glow = (pow( (minGlow*2.0) * sin(mouse.y / 0.89), 0.8));
		glow = ( glow < minGlow )?minGlow:glow;
		modulator += (mouse.y ) * 20.0;
		
		//o1
		float n = nearf(position.y, o1 + resolution.y* 0.5,(glow + f * modulator))*0.5;
		o += c1 * n; 
		vec4( n,0.0,0.0, 0.5);
		if(near(position.y,o1_1 + resolution.y*0.5 ,line_thick)){ o += c1; }
		//*
		//o2
		n = nearf(position.y, o2 + resolution.y* 0.5,(glow + f * modulator))*0.5;
		o += c2 * n; 
		vec4( n,0.0,0.0, 0.5);
		if(near(position.y,o2_1 + resolution.y*0.5 ,line_thick)){ o += c2; }
		
		//o3
		n = nearf(position.y, o3 + resolution.y* 0.5,(glow + f * modulator))*0.5;
		o += c3 * n; 
		vec4( n,0.0,0.0, 0.5);
		if(near(position.y,o3_1 + resolution.y*0.5 ,line_thick)){ o += c3; }
		
		
		//o4
		n = nearf(position.y, o4 + resolution.y* 0.5,(glow + f * modulator))*0.5;
		o += c4 * n; 
		vec4( n,0.0,0.0, 0.5);
		if(near(position.y,o4_1 + resolution.y*0.5 ,line_thick)){ o += c4; }
		
		
		//o5
		n = nearf(position.y, o5 + resolution.y* 0.5,(glow + f * modulator))*0.5;
		o += c5 * n; 
		vec4( n,0.0,0.0, 0.5);
		if(near(position.y,o5_1 + resolution.y*0.5 ,line_thick)){ o += c5; }
		
		//o6
		n = nearf(position.y, o6 + resolution.y* 0.5,(glow + f * modulator))*0.5;
		o += c6 * n; 
		vec4( n,0.0,0.0, 0.5);
		if(near(position.y,o6_1 + resolution.y*0.5 ,line_thick)){ o += c6; }
		
		//o7
		n = nearf(position.y, o7 + resolution.y* 0.5,(glow + f * modulator))*0.5;
		o += c7 * n; 
		vec4( n,0.0,0.0, 0.5);
		if(near(position.y,o7_1 + resolution.y*0.5 ,line_thick)){ o += c7; }
		//*
		//o8
		n = nearf(position.y, o8 + resolution.y* 0.5,(glow + f * modulator))*0.5;
		o += c8 * n; 
		vec4( n,0.0,0.0, 0.5);
		if(near(position.y,o8_1 + resolution.y*0.5 ,line_thick)){ o += c8; }
		
		//o9
		n = nearf(position.y, o9 + resolution.y* 0.5,(glow + f * modulator))*0.5;
		o += c9 * n; 
		vec4( n,0.0,0.0, 0.5);
		if(near(position.y,o9_1 + resolution.y*0.5 ,line_thick)){ o += c9; }
		
		//o10
		n = nearf(position.y, o10 + resolution.y* 0.5,(glow + f * modulator))*0.5;
		o += c10 * n; 
		vec4( n,0.0,0.0, 0.5);
		if(near(position.y,o10_1 + resolution.y*0.5 ,line_thick)){ o += c10; }
		
		//o11
		n = nearf(position.y, o11 + resolution.y* 0.5,(glow + f * modulator))*0.5;
		o += c11 * n; 
		vec4( n,0.0,0.0, 0.5);
		if(near(position.y,o11_1 + resolution.y*0.5 ,line_thick)){ o += c11; }
		
		//*/
		gl_FragColor = o;
	
	}
}