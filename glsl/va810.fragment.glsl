/*
Just made it a little bit more interactive. @RicoTweet 
*/

#ifdef GL_ES
precision highp float;
#endif

#define SPHERE1 1
#define SPHERE2 2
#define PLANE1 3

uniform float time;
uniform vec2 mouse; 
uniform vec2 resolution;

struct materialProperties
{
  vec3 specular;
  vec3 diffuse;
  vec3 ambient;
};
struct sphere {
  float radius;
  vec3 center;
  materialProperties matProp;
};
struct plane {
  vec3 normal;
  vec4 Eq;
  materialProperties matProp;
};  
uniform sampler2D tex0;
vec4 lmodel_ambient = vec4( 0.2, 0.2, 0.2, 1.0 );
vec4 mat_ambient = vec4( 0.2, .2, .2, 1.0 );
vec4 mat_diffuse = vec4( .5, 0.5, 0.5, 1.0 );
vec4 mat_specular = vec4(1.0,1.0,1.0,1.0);
vec3 camera = vec3(-50.0,20.0,100.0);
float shininess = 50.0;
vec4 specular = vec4( 1.0, 1.0, 1.0, 1.0 );
vec4 ambient = vec4( 0.8, 0.1, 0.1, 1.0 );
vec4 diffuse = vec4( 1.0, 0.1, 0.1, 1.0 );

vec3 lPos = vec3( 10.0, 15.0, 5.0 );

// Sphere Parameters
vec3 center = vec3(20.0,0.0,-10.0);
float radius = 10.0;

vec3 center2 = vec3(-20.0,0.0,-10.0);
float radius2 = 7.0;

//................//

//plane parameters
vec3 planeNormal = vec3(0.0,1.0,0.0);
vec4 planeEq = vec4(0.0,1.0,0.0,10.0);
//..................//
float calcShadow (vec3 point,vec3 rayDirection, int id); //fwd declaration

vec3 computeLight(vec3 iPoint, vec3 iNormal, int id)
{
	vec3 normal,lightDir,halfVector;
	vec3 n,halfV,viewV,ldir;
	float NdotL,NdotHV;
	vec4 diffuse1, ambient1;
	
	lightDir = normalize(lPos- iPoint);
	
	viewV = normalize (camera - iPoint);
	halfVector = normalize(lightDir + viewV);
	 
        float shadowFactor = calcShadow (iPoint,lPos, id);
  	

	/* Compute the diffuse, ambient and globalAmbient terms */
	diffuse1 = mat_diffuse* diffuse ;
	ambient1 = mat_ambient *ambient;
	ambient1 += lmodel_ambient * mat_ambient;
  	if(shadowFactor < 1.0)
        {
          shadowFactor = 0.0;
          diffuse1 = 0.0 * diffuse1 ;
        }

	/* a fragment shader can't write a verying variable, hence we need
	a new variable to store the normalized interpolated normal */
	n = normalize(iNormal);
	
	vec4 color = ambient1;
	
	/* compute the dot product between normal and ldir */
	NdotL = max(dot(n,lightDir),0.0);

	if (NdotL > 0.0) {
	//	halfV = normalize(halfVector);
		NdotHV = max(dot(n,halfVector),0.0);
		color += mat_specular * specular * pow(NdotHV,shininess) ;
		color += diffuse1 * NdotL;
	}
	return color.rgb;
}
	

int sphereIntersect(vec3 rayDir, vec3 rayOrigin, out float t1, in vec3 sCenter, in float sRadius)
{
	
	rayDir = normalize(rayDir);
	float B = 2.0 *( ( rayDir.x * (rayOrigin.x - sCenter.x ) )+  ( rayDir.y * (rayOrigin.y - sCenter.y )) + ( rayDir.z * (rayOrigin.z - sCenter.z ) ));
	float C = pow((rayOrigin.x - sCenter.x),2.0) + pow((rayOrigin.y - sCenter.y),2.0) + pow((rayOrigin.z - sCenter.z),2.0) - pow(sRadius,2.0);
	
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
	rayDir= normalize(rayDir);
	float b = dot(planeNormal, rayDir );
	if(b < 0.0) // b>0 means plane is away from the ray
	{
         	float a = - dot(rayOrigin,planeNormal) - planeEq.w;
          	t1 = a/b ;
          	if(t1 > 0.0) //t <0 means that plane ray intersection is behind the camera
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


int checkIntersection(out float t1,in vec3 rayOrigin,  in vec3 rayDirection)
{
 float tmin = 100000.0;
 t1=0.0;
 int id=0;
 rayDirection = normalize (rayDirection);
 if(sphereIntersect(rayDirection,rayOrigin, t1, center, radius) == 1)
 {
  if(t1 < tmin)
  {
   id = SPHERE1;
   tmin = t1; 
  }
 }
 if(sphereIntersect(rayDirection,rayOrigin, t1, center2, radius2) == 1)
 {
  if(t1 < tmin)
  {
   id = SPHERE2;
   tmin = t1; 
  }
 }
 if(planeIntersect(rayDirection,rayOrigin, t1) == 1)
 {
  if(t1 < tmin)
  {
    id= PLANE1;
    tmin = t1; 
  }
 }
 
  if (id!=0) 
  {
    t1=tmin;
    return id;
  }
 else return 0;
}


float calcShadow (vec3 point,vec3 rayDirection, int id)
{
 float power = 1.0;
 float t1=0.0;
 if(sphereIntersect(rayDirection,point, t1, center, radius) == 1 && id != SPHERE1)
 {
  power+=1.0;
 }
 else if(sphereIntersect(rayDirection,point, t1, center2, radius2) == 1 && id != SPHERE2 )
 {
    power+=1.0;
 }
 else if(planeIntersect(rayDirection,point, t1) == 1 && id != PLANE1)
 {
   power+=1.0;
 }
 return 1.0/power;
}

vec3 calculateNormal (int id, vec3 point) 
{
 vec3 normal;
 if(id==SPHERE1)
 {
  normal.x = (point.x - center.x)/radius ;
  normal.y = (point.y - center.y)/radius ;
  normal.z = (point.z - center.z)/radius ;
 }
 else if(id==SPHERE2)
 {
  normal.x = (point.x - center2.x)/radius2 ;
  normal.y = (point.y - center2.y)/radius2 ;
  normal.z = (point.z - center2.z)/radius2 ;
 }
 else if(id == PLANE1)
 {
  normal = planeNormal;
 }
 return normal;
}


void main()
{
	//Setting all material properties
	vec2 pos = 180.0 * mouse.xy / resolution.xy;  	
  
  	vec2 p =  -1.0 + (gl_FragCoord.xy/500.0) * 2.0;
        vec3 rayDirection  =   normalize(vec3(p, -1.0));
	vec3 lightColor = vec3(0.0,0.0,0.0);
	vec3 wTex = vec3(0.0,0.0,0.0);
	float t1=0.0; // variable for ray parameter as in r = ro + t* rd
  	vec3 iPoint,iNormal;
  	
        int id = checkIntersection(t1,camera, rayDirection);    
         
  	if( id>0 )
        {	
	 iPoint.x = camera.x + rayDirection.x * t1 + sin(pos.x*20.0) * 4.0;
	 iPoint.y = camera.y + rayDirection.y * t1 + cos(time * 7.0) * 2.0;
	 iPoint.z = camera.z + rayDirection.z * t1 + sin(time * 1.0);
		
	 iNormal.xyz = calculateNormal (id, iPoint) ;
          	
         lightColor = computeLight(iPoint,iNormal, id);
	 
         if(id==PLANE1)
         { 
          wTex = texture2D(tex0,p).rgb;
          gl_FragColor = vec4(lightColor ,1.0) ;
	 }
         else
          gl_FragColor = vec4(lightColor,1.0); 
        }   	
}
