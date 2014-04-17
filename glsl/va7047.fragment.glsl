
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// bonniemathew@gmail.com - Sphere using RayMarching.

float findDistToSphere(vec3 rayPos) {
	return length(rayPos) - 0.04;
}

vec3 getSphereNormal(vec3 rayPos, vec4 spherePos) {
	vec3 normal = rayPos - spherePos.xyz;
	normal = normalize(normal);
	return normal;
}


void main( void )
{
    
    vec2 scrnPos = (gl_FragCoord.xy / resolution.xy) * vec2(2.0, 1.0) - vec2(1.0, .50);
    vec2 newMousePos = (mouse.xy / resolution.xy) * vec2(2.0, 2.0) - vec2(1.0, 1.0);	
    vec4 spherePos = vec4 (0.0, 0.0, 0.0, 1.0);	
    
    // Cam Details 	
    const float camZ = 0.2;	
    vec3 camPos = vec3(0.0, 0.0, camZ);
    vec3 camLookAt = vec3(0.0, 0.0, -1.0);
    vec3 camUp = vec3(0.0, 1.0, 0.0);
    vec3 camDir = normalize(camLookAt - camPos);
    vec3 camRight = normalize(cross(camDir, camUp));
       
    vec3 rayStartPos = camPos;
    vec3 rayDir = normalize(camRight * scrnPos.x + camUp * scrnPos.y + camDir * 1.0);
    const int MAX_STEPS = 32;	
    const float MAX_DIST = camZ;
    vec3 rayNewPos = rayStartPos;
    float distTravelled = 0.0;	
    
    vec3 sphereNormal;
    vec4 sphereDiffColor = vec4(1.0); 
    vec4 RED = vec4(1.0, 0.0, 0.0, 1.0);
    vec3 LIGHT_POS = normalize(vec3(0.3, 0.2, 0.3));
    LIGHT_POS = vec3(mouse.xy * vec2(2.0, 2.0) - vec2(1.0,1.0), 1.0);
    	
    for(int i=0; i<MAX_STEPS; i++) {

	    float dist = findDistToSphere(rayNewPos);
	    rayNewPos += rayDir * dist;
	    distTravelled += dist;
	    
	    if(abs(dist) < 0.001) {
		sphereNormal = getSphereNormal(rayNewPos, spherePos);		    
	    	float diffCoeff = clamp( dot( sphereNormal, LIGHT_POS ), 0.0, 1.0);;
	    	sphereDiffColor = (distTravelled / MAX_DIST) * diffCoeff * RED;		    
		break;
	    }
	    
	    if(distTravelled > float(MAX_DIST))
		    break;
	    
    }
   
    gl_FragColor = sphereDiffColor;
}