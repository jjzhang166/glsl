#ifdef GL_ES
precision highp float;
#endif

vec4 lmodel_ambient = vec4( 0.2, 0.2, 0.2, 1.0 );
vec4 mat_ambient = vec4( 0.7, 0.0, 0.0, 1.0 );
vec4 mat_diffuse = vec4( 0.7, 0.0, 0.0, 1.0 );
vec4 mat_specular = vec4(1.0,1.0,1.0,1.0);
vec3 camera = vec3(0.0,10.0,30.0);
float shininess = 25.0;
vec4 specular = vec4( 1.0, 1.0, 1.0, 1.0 );
vec4 ambient = vec4( 0.3, 0.3, 0.3, 1.0 );
vec4 diffuse = vec4( 0.7, 0.7, 0.7, 1.0 );

vec3 lPos = vec3( 0.0, 15.0, 0.0 );

vec3 computeLight(vec3 iPoint, vec3 iNormal)
{
	vec3 normal,lightDir,halfVector;
	vec3 n,halfV,viewV,ldir;
	float NdotL,NdotHV;
	vec4 diffuse1, ambient1;
	
	lightDir = normalize(lPos- iPoint);
	
	viewV = normalize (camera - iPoint);
	halfVector = normalize(lightDir + viewV);
	
	/* Compute the diffuse, ambient and globalAmbient terms */
	diffuse1 = mat_diffuse* diffuse;
	ambient1 = mat_ambient *ambient;
	ambient1 += lmodel_ambient * mat_ambient;

	/* a fragment shader can't write a verying variable, hence we need
	a new variable to store the normalized interpolated normal */
	n = normalize(iNormal);
	
	vec4 color = ambient1;
	
	/* compute the dot product between normal and ldir */
	NdotL = max(dot(n,lightDir),0.0);

	if (NdotL > 0.0) {
	//	halfV = normalize(halfVector);
		NdotHV = max(dot(n,halfVector),0.0);
		color += mat_specular * specular * pow(NdotHV,shininess);
		color += diffuse1 * NdotL;
	}
	return color.rgb;
}
	

int sphereIntersect(vec3 rayDir, vec3 rayOrigin, out float t1)
{
	vec3 center = vec3(0.0,0.0,0.0);
	float radius = 5.0;
	
	rayDir = normalize(rayDir);
	float B = 2.0 *( ( rayDir.x * (rayOrigin.x - center.x ) )+  ( rayDir.y * (rayOrigin.y - center.y )) + ( rayDir.z * (rayOrigin.z - center.z ) ));
	float C = pow((rayOrigin.x - center.x),2.0) + pow((rayOrigin.y - center.y),2.0) + pow((rayOrigin.z - center.z),2.0) - pow(radius,2.0);
	
	float D = B*B - 4.0*C ;
	
	if(D>=0.0)
	{
		t1= (-B - pow(D, .5)) / 2.0;
		if (t1 < 0.0)
		{
			t1 = (-B + pow(D, .5)) / 2.0;
			if( t1 < 0.0)
				return 0; // both solution of quadratic equation are <0 hence no intersection
			else
				return 1;
		}
		else
			return 1; // first solution is positive and hence successful intersection
	}
	else
		return 0; //since determinant of quadratic equation <0 so no solution and hence no intersection
}

int planeIntersect(vec3 rayDir, vec3 rayOrigin, out float t1)
{
	vec3 planeNormal = vec3(0.0,1.0,0.0);
	vec4 planeEq = vec4(1.0,1.0,1.0,10);
	rayDir= normalize(rayDir);
	float b = dot(planeNormal, rayDir );
	if(b < 0.0)
	{
         	float a = - dot(rayOrigin,planeNormal) - planeEq.w;
          	t1 = a/b ;
          	if(t1 > 0.0)
         		return  1;
          	else 
                  	return 0;
	}
	else
        {
          	t1= 0.0;
		return 0; //no intersection or intersection behind camera
        }
}

void main()
{
	vec3 rayDirection  =   normalize(vec3( -1.0 + (gl_FragCoord.xy/500.0) * 2.0, -1.0));
	vec3 lightColor = vec3(0.0,0.0,0.0);
	vec3 wTex = vec3(0.0,0.0,0.0);
	float t1=0.0; // variable for ray parameter as in r = ro + t* rd
  	vec3 iPoint,iNormal;
  	
  		
	if(sphereIntersect(rayDirection, camera, t1) == 1)
	{
		vec3 center = vec3(0.0,0.0,0.0);
		float radius = 5.0;
		iPoint.x = camera.x + rayDirection.x * t1;
		iPoint.y = camera.y + rayDirection.y * t1;
		iPoint.z = camera.z + rayDirection.z * t1;
		
		iNormal.x = (iPoint.x - center.x)/radius ;
		iNormal.y = (iPoint.y - center.y)/radius ;
		iNormal.z = (iPoint.z - center.z)/radius ;
          	
          	lightColor = computeLight(iPoint,iNormal);
		gl_FragColor = vec4(lightColor,1.0);
	}  
    	else if(planeIntersect(rayDirection, camera, t1) == 1)
	{
		//calculating point of intersection
          	iPoint.x = camera.x + rayDirection.x * t1;
		iPoint.y = camera.y + rayDirection.y * t1;
		iPoint.z = camera.z + rayDirection.z * t1;
		
		//calculating normal at point of intersection
		iNormal = vec3 (0.0,1.0,0.0);
          	
          	lightColor = computeLight(iPoint,iNormal);
		gl_FragColor = vec4(lightColor,1.0) + .2;          
	}
}
