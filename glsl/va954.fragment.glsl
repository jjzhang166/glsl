


#ifdef GL_ES
precision highp float;
#endif

#define SPHERE1 1
#define SPHERE2 2
#define PLANE1 3

struct materialProperties
{
  vec4 specular;
  vec4 diffuse;
  vec4 ambient;
  float shininess;
};
struct sphere {
  float radius;
  vec3 center;
  materialProperties matProp;
};
struct plane {
  vec3 normal;
  vec4 eq;
  materialProperties matProp;
};  

// define primitives
sphere sphere1, sphere2;
plane plane1;  

uniform sampler2D tex0;
vec4 lmodel_ambient = vec4( 0.2, 0.2, 0.2, 1.0 );
//vec4 mat_ambient = vec4( 0.7, .2, .2, 1.0 );
//vec4 mat_diffuse = vec4( 1.0, 0.0, 0.0, 1.0 );
//vec4 mat_specular = vec4(1.0,1.0,1.0,1.0);
vec3 camera = vec3(0.0,10.0,50.0);
//float shininess = 20.0;
vec4 specular = vec4( 0.3, 0.3, 0.3, 1.0 );
vec4 ambient = vec4( 0.8, 0.5, 0.1, 1.0 );
vec4 diffuse = vec4( .5, 0.5, 0.5, 1.0 );

vec3 lPos = vec3( 10.0, 10.0, 5.0 );

vec3 center = vec3 (20.0,0.0,-5.0);
float radius = 10.0;
vec3 center2 = vec3 (-20.0,10.0,-1.0);
float radius2 = 20.0;
vec4 planeEq = vec4 (0.0,1.0,0.0,10.0);
vec3 planeNormal = vec3 (0.0,1.0,0.0);


float calcShadow (vec3 point,vec3 rayDirection, int id); //fwd declaration
vec3 computeLight(vec3 iPoint, vec3 iNormal, int id, vec4 mat_ambient, vec4 mat_diffuse,vec4  mat_specular, float shininess)
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
             diffuse1 = shadowFactor * diffuse1 ;
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
	t1=0.0;
	rayDir = normalize(rayDir);
	float B = 2.0 *( ( rayDir.x * (rayOrigin.x - sCenter.x ) )+  ( rayDir.y * (rayOrigin.y - sCenter.y )) + ( rayDir.z * (rayOrigin.z - sCenter.z ) ));
	float C = pow((rayOrigin.x - sCenter.x),2.0) + pow((rayOrigin.y - sCenter.y),2.0) + pow((rayOrigin.z - sCenter.z),2.0) - pow(sRadius,2.0);
	
	float D = B*B - 4.0*C ;
	
	if(D>0.0)
	{
		t1= (-B - pow(D, .5)) / 2.0;
		if (t1 > 0.0)
		{
		        return 1;  
			 
		}
		
	}
	 
		return 0; //since determinant of quadratic equation <0 so no solution and hence no intersection
}

int planeIntersect(vec3 rayDir, vec3 rayOrigin, out float t1)
{
	rayDir= normalize(rayDir);
	float b = dot(plane1.normal, rayDir );
	if(b <= 0.0) // b>0 means plane is away from the ray
	{
         	float a = - dot(rayOrigin,planeNormal) - plane1.eq.w;
          	t1 = a/b ;
          	if(t1 >= 0.0) //t <0 means that plane ray intersection is behind the camera
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
 if(sphereIntersect(rayDirection,rayOrigin, t1, sphere1.center, sphere1.radius) == 1)
 {
  if(t1 < tmin)
  {
   id = SPHERE1;
   tmin = t1; 
  }
 }
 if(sphereIntersect(rayDirection,rayOrigin, t1, sphere2.center, sphere2.radius) == 1)
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
 if(sphereIntersect(rayDirection,point, t1, sphere1.center, sphere1.radius) == 1 && id != SPHERE1)
 {
  power+=1.0;
 }
 else if(sphereIntersect(rayDirection,point, t1, sphere2.center, sphere2.radius) == 1 && id != SPHERE2 )
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
  normal.x = (point.x - sphere1.center.x)/sphere1.radius ;
  normal.y = (point.y - sphere1.center.y)/sphere1.radius ;
  normal.z = (point.z - sphere1.center.z)/sphere1.radius ;
 }
 else if(id==SPHERE2)
 {
  normal.x = (point.x - sphere2.center.x)/sphere2.radius ;
  normal.y = (point.y - sphere2.center.y)/sphere2.radius ;
  normal.z = (point.z - sphere2.center.z)/sphere2.radius;
 }
 else if(id == PLANE1)
 {
  normal = planeNormal;
 }
 return normal;
}

vec3 assignColor(int id, vec3 iPoint, vec3 iNormal )
{
  if (id == SPHERE1)
  { 	
       	return computeLight(iPoint,iNormal, id,sphere1.matProp.ambient, sphere1.matProp.diffuse,sphere1.matProp.specular ,sphere1.matProp.shininess ); 
  }
  else if(id== SPHERE2)
  {
       	return computeLight(iPoint,iNormal, id,sphere2.matProp.ambient, sphere2.matProp.diffuse,sphere2.matProp.specular ,sphere2.matProp.shininess );
  }
  else if(id==PLANE1)
  { 
     	return computeLight(iPoint,iNormal, id,plane1.matProp.ambient, plane1.matProp.diffuse,plane1.matProp.specular ,plane1.matProp.shininess );
  }
  else
    	return vec3(0.0,0.0,0.0);
}


void main()
{
	//Setting all material properties
	  
  	sphere1.radius = radius;
  	sphere1.center = center;
  	sphere1.matProp.ambient = vec4 (0.0,0.0,.3,1.0);
  	sphere1.matProp.diffuse = vec4 (0.0,0.0,0.7,1.0);
  	sphere1.matProp.specular = vec4 (1.0,1.0,1.0,1.0);
  	sphere1.matProp.shininess = 75.0;
  
  	sphere2.radius = radius2;
  	sphere2.center = center2;
  	sphere2.matProp.ambient = vec4 (0.0,0.3,0.0,1.0);
  	sphere2.matProp.diffuse = vec4 (0.0,0.7,0.0,1.0);
  	sphere2.matProp.specular = vec4 (1.0,1.0,1.0,1.0);
  	sphere2.matProp.shininess = 100.0;
  
  	plane1.eq = planeEq;
  	plane1.normal = planeNormal;
  	plane1.matProp.ambient = vec4 (0.3,0.3,0.3,1.0);
  	plane1.matProp.diffuse = vec4 (1.0,1.0,1.0,1.0);
  	plane1.matProp.specular = vec4 (1.0,1.0,1.0,1.0);
  	plane1.matProp.shininess = 5.0;
  
  	vec2 p =  -1.0 + (gl_FragCoord.xy/500.0) * 2.0;
        vec3 rayDirection  =   normalize(vec3(p, -1.0));
	vec3 lightColor;
	vec3 wTex = vec3(0.0,0.0,0.0);
	float t1=0.0; // variable for ray parameter as in r = ro + t* rd
  	vec3 iPoint,iNormal;
  	
        int id = checkIntersection(t1,camera, rayDirection);    
         
  	if( id>0 )
        {	
	 iPoint.x = camera.x + rayDirection.x * t1;
	 iPoint.y = camera.y + rayDirection.y * t1;
	 iPoint.z = camera.z + rayDirection.z * t1;
		
	 iNormal.xyz = calculateNormal (id, iPoint) ;
          wTex = texture2D(tex0,p).rgb;
 	 lightColor.xyz = assignColor (id, iPoint, iNormal)   ;
         gl_FragColor=vec4(lightColor, 1.0);
         
         //calculating reflection vector and color; iteration since recursion is not supported
         vec3 refColor; 
         vec3 ref =reflect (rayDirection,iNormal);
         t1=0.0; 
         
         int id2 = checkIntersection(t1,iPoint, ref);    
         if( id2>0 )
         {
           refColor= vec3(1.0,1.0,1.0);
	 iPoint.x = iPoint.x + ref.x * t1;
	 iPoint.y = iPoint.y + ref.y * t1;
	 iPoint.z = iPoint.z + ref.z * t1;
		
	 iNormal.xyz = calculateNormal (id2, iPoint) ;
         
         if(id2==PLANE1 && id!=PLANE1)
         { 
           wTex = texture2D(tex0,p).rgb;
           refColor = computeLight(iPoint,iNormal, id2,sphere1.matProp.ambient, sphere1.matProp.diffuse,sphere1.matProp.specular ,sphere1.matProp.shininess );
           gl_FragColor = vec4(gl_FragColor.rgb * .7 + .3 * refColor ,.5);  	
	 }
         if (id2 == SPHERE1 && id!=SPHERE1)
         { 	
         	refColor *= computeLight(iPoint,iNormal, id2,sphere1.matProp.ambient, sphere1.matProp.diffuse,sphere1.matProp.specular ,sphere1.matProp.shininess );
           	gl_FragColor = vec4(gl_FragColor.rgb * .7 + .3 * refColor ,.5);  	
         }
	 if(id2== SPHERE2 && id!= SPHERE2)
         {
           	refColor *= computeLight(iPoint,iNormal, id2,sphere2.matProp.ambient, sphere2.matProp.diffuse,sphere2.matProp.specular ,sphere2.matProp.shininess );
           	gl_FragColor = vec4(gl_FragColor.rgb * .7 + .3 * refColor ,.5);  	
         }
         
         }
         
        }
  	else discard;
}
