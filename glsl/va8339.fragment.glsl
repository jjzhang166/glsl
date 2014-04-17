#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.x *= 1.5;
	position.x -= 0.3;
	vec3 color = vec3(0.5,0.5,0.5);
	float value = 0.5;

	vec2 point[5];
	point[0] = vec2(-1.0,-1.0);
	point[1] = vec2(-1.0,-1.5);
	point[2] = vec2(-1.0,-2.0);
	point[3] = vec2(1.0,-2.0);
	point[4] = vec2(2.0,-2.0);
	
	vec2 tpoint = vec2(0.5,0.5);
	
	vec2 pt = vec2(0.0, 0.0);
	
	float t[5];
	t[0] = time*3.0;
	t[1] = time*3.5;
	t[2] = time*2.0;
	t[3] = time*4.0;
	t[4] = time*1.5;
	
	float k = 100.0;
	
	for (int a = 0; a < 5; a++){
		float dst = distance(position, point[a]);
		
		// The value of the underlying function at this point
		// It's a sum of sine waves from point[a]
		value += 0.1*sin(t[a]+dst*k);
		
		// The colour at this point (not rendered)
		color += 0.1*sin(t[a]+dst*k);
		
		// The partial derivatives of the function
		pt.x += -(k*0.1*(point[a].x-position.x)*cos(k*dst+t[a]))/dst;
		pt.y += -(k*0.1*(point[a].y-position.y)*cos(k*dst+t[a]))/dst;
	}
	
	vec2 posn = vec2(0.0,0.0);
	//vec3 norm = normalize(vec3(-pt.x, -pt.y, 1.0)); // Use pt to create normal
	vec3 norm = normalize(vec3(-pt.x, -pt.y, 1.0)); // Use pt to create normal

	float eta = 0.8;
	vec3 incomingdir = vec3(0.0,0.0,1.0);

	float m=1.0-eta*eta*(1.0-dot(norm,incomingdir)*dot(norm,incomingdir));
	vec3 refracteddir = normalize(eta*incomingdir-(eta*dot(norm,incomingdir)+sqrt(m))*norm);
	posn = value*refracteddir.xy/20.0; // Calculate point offset.
	position+=posn/1.0;
	//position+=0.5/20.0 - value/20.0;
	
	//Render square
	/*if (position.x > 0.4 && position.x < 0.9 && position.y > 0.1 && position.y < 0.6)	{
		gl_FragColor = vec4(vec3(0.0,0.2+0.2*cos((position.x)*20.0),0.2+0.4*sin((position.x)*20.0)), 1.0);
	} else	
		gl_FragColor = vec4(color*0.0, 1.0);*/
	
	// Render circle
	if (distance(position, vec2(0.5,0.5)) < 0.3 && distance(position, vec2(0.5,0.5)) > 0.29) {
		gl_FragColor = vec4(vec3(0.8,0.8,0.0), 1.0);
	}

	// Render circle
	if (distance(position, vec2(0.5,0.5)) < 0.2 && distance(position, vec2(0.5,0.5)) > 0.19) {
		gl_FragColor = vec4(vec3(0.8,0.8,0.0), 1.0);
	}

			
	float dt = dot(vec3(0.0,0.0,1.0), norm);
	if (dt < 1.0 && dt > 0.1){
		//gl_FragColor = vec4(vec3(0.01,0.1,0.1), 1.0);
	}
}