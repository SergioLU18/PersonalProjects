// TC2008B. Sistemas Multiagentes y Gráficas Computacionales
// C# client to interact with Python
// Sergio. Julio 2021
// Actualizado Lorena Mtz E. Agosto 2021

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Networking;

public class AgentController : MonoBehaviour
{
    public List <GameObject> agentPrefab;
    //public GameObject agent2Prefab;
    public GameObject[] startWaypoint;
    public GameObject[] parkingLots;
    public GameObject[] street;
    public GameObject[] r1;
    public GameObject[] r2;
    public GameObject[] r3;

    List <string> destiny;
    List<bool> leave;


    public int clonesOfAgent1;
    public int clonesOfAgent2;
    string lot;
    public float speed;

    List <GameObject> agents;
    List <bool> park;
    List<bool> parked;
    List<bool> readyExit;
    List<int> streetIndex;
    public float timeToUpdate = 5.0f;
    private float timer;
    float dt;
    //int streetIndex=0;
    GameObject currentLot;
    float distance = 0.25f;
    List <int> side;
    List<int> rIndex;
    int destinyIndex = 0;
    int prefabIndex = 0;
    int leaveIndex = 0;
    int instanceCounter = 0;

    // IEnumerator - yield return
    IEnumerator SendData(string data)
    {
        WWWForm form = new WWWForm();
        form.AddField("bundle", "the data");
        string url = "http://localhost:8585";   //El puerto debe coincidir con el del server
        using (UnityWebRequest www = UnityWebRequest.Post(url, form))
        {
            byte[] bodyRaw = System.Text.Encoding.UTF8.GetBytes(data);
            www.uploadHandler = (UploadHandler)new UploadHandlerRaw(bodyRaw);
            www.downloadHandler = (DownloadHandler)new DownloadHandlerBuffer();
            
            www.SetRequestHeader("Content-Type", "application/json");

            yield return www.SendWebRequest();          
            if (www.isNetworkError || www.isHttpError)
            {
                Debug.Log(www.error);
            }
            else
            {
                
                string txt = www.downloadHandler.text.Replace('\'', '\"');
                txt = txt.TrimStart('"', '{',  'd', 'a', 't', 'a', ':');
                
                txt = txt.TrimEnd('}');
            
                if (instanceCounter < agentPrefab.Count)
                {
                    if (txt != "quitar" && txt != "none")
                    {
                        Vector3 spawn = startWaypoint[0].transform.position;
                        destiny.Add(txt);
                        leave.Add(false);
                        park.Add(false);
                        parked.Add(false);
                        readyExit.Add(false);
                        side.Add(0);
                        rIndex.Add(0);
                        streetIndex.Add(0);
                        Debug.Log(agentPrefab.Count);
                        Debug.Log(prefabIndex);
                        agents.Add(Instantiate(agentPrefab[prefabIndex], spawn, Quaternion.Euler(0, -90, 0)));
                        prefabIndex += 1;
                        instanceCounter += 1;
                    }
                }
                if (txt == "quitar")
                {
                    leave[leaveIndex] = true;
                    leaveIndex += 1;

                }
                
                
                string[] strs = txt.Split(new string[] { "}, {" }, StringSplitOptions.None);
                
            }
        }

    }

    // Start is called before the first frame update
    void Start()
    {
        int numOfAgents = clonesOfAgent1 + clonesOfAgent2;
        Vector3 spawn = startWaypoint[0].transform.position;
        agents = new List<GameObject>();
        destiny = new List<string>();
        leave = new List<bool>();
        park = new List<bool>();
        parked = new List<bool>();
        readyExit = new List<bool>();
        side = new List<int>();
        rIndex = new List<int>();
        streetIndex = new List<int>();


    }

    // Update is called once per frame
    void Update()
    {

        timer -= Time.deltaTime;
        dt = 1.0f - (timer / timeToUpdate); 

        if (timer < 0)
        {
    #if UNITY_EDITOR    //https://docs.unity3d.com/Manual/PlatformDependentCompilation.html
                timer = timeToUpdate; 
                Vector3 fakePos = new Vector3(3.44f, 0, -15.707f);
                string json = EditorJsonUtility.ToJson(fakePos);
                StartCoroutine(SendData(json));
    #endif
        }

        for (int k = 0; k<destiny.Count;k++) 
        {
            if(agents[k].active) {
                movement(k);
            }
        } 
    }

    void movement(int k)
    {
        GameObject exit = startWaypoint[1];
        Vector3 a = agents[k].transform.position;

        if (!park[k])
        {
            agents[k].transform.position = Vector3.MoveTowards(agents[k].transform.position, street[streetIndex[k]].transform.position, speed * Time.deltaTime);

            agents[k].transform.LookAt(street[streetIndex[k]].transform);
        }
        

        if (agents[k].transform.position == street[streetIndex[k]].transform.position)
        {
            streetIndex[k] += 1;
        }
        if (streetIndex[k] == street.Length)
        {
            streetIndex[k] = 0;
        }
        
        for (int i = 0; i<parkingLots.Length;i++)
        {
            if (parkingLots[i].gameObject.name==destiny[k])
            {
                currentLot = parkingLots[i];
                side[k] = i + 1;
            }
        }

        if (agents[k].transform.position == currentLot.transform.position)
        {
            parked[k] = true;
        }

        if (!parked[k])
        {
            if (side[k] <= 10 && agents[k].transform.position.x < 4)
            {
                if (Math.Abs(agents[k].transform.position.z - currentLot.transform.position.z) < distance)
                {
                    agents[k].transform.position = Vector3.MoveTowards(agents[k].transform.position, currentLot.transform.position, speed * Time.deltaTime);
                    agents[k].transform.LookAt(currentLot.transform);
                    park[k] = true;
                    
                }
            }
            else if (side[k] > 10 && agents[k].transform.position.x > 4)
            {
                if (Math.Abs(agents[k].transform.position.z - currentLot.transform.position.z) < distance)
                {
                    agents[k].transform.position = Vector3.MoveTowards(agents[k].transform.position, currentLot.transform.position, speed * Time.deltaTime);
                    agents[k].transform.LookAt(currentLot.transform);
                    park[k] = true;
                }
            }
        }

        if (leave[k])
        {
            if (agents[k].transform.position.x < 4)
            {
                Vector3 b = agents[k].transform.position;
                Vector3 c = new Vector3(-2.5f, agents[k].transform.position.y, agents[k].transform.position.z);
                agents[k].transform.position = Vector3.MoveTowards(b, c, speed * Time.deltaTime);
                if (b==c)
                {
                    leave[k] = false;
                    readyExit[k] = true;
                }
                
            }
            else if (agents[k].transform.position.x > 4)
            {
                Vector3 b = agents[k].transform.position;
                Vector3 c = new Vector3(11.0f, agents[k].transform.position.y, agents[k].transform.position.z);
                agents[k].transform.position = Vector3.MoveTowards(b, c, speed * Time.deltaTime);
                readyExit[k] = true;
                if (b == c)
                {
                    leave[k] = false;
                    readyExit[k] = true;
                }
            }
        }
        if (readyExit[k])
        {
            if (side[k] > 10)
            {
                agents[k].transform.position = Vector3.MoveTowards(agents[k].transform.position, r1[rIndex[k]].transform.position, speed * Time.deltaTime);
                agents[k].transform.LookAt(r1[rIndex[k]].transform);
                if (agents[k].transform.position == r1[rIndex[k]].transform.position)
                {
                    rIndex[k] += 1;
                }
                if (rIndex[k] == r1.Length)
                {
                    rIndex[k] = 0;
                    agents[k].SetActive(false);
                }


            }
            if (side[k]>2 && side[k] <= 10 )
            {
                agents[k].transform.position = Vector3.MoveTowards(agents[k].transform.position, r2[rIndex[k]].transform.position, speed * Time.deltaTime);
                agents[k].transform.LookAt(r2[rIndex[k]].transform);
                if (agents[k].transform.position == r2[rIndex[k]].transform.position)
                {
                    rIndex[k] += 1;
                }
                if (rIndex[k] == r2.Length)
                {
                    rIndex[k] = 0;
                    agents[k].SetActive(false);
                }
               

            }
            if (side[k]>0 && side[k] <3)
            {

                agents[k].transform.position = Vector3.MoveTowards(agents[k].transform.position, r3[rIndex[k]].transform.position, speed * Time.deltaTime);
                agents[k].transform.LookAt(r3[rIndex[k]].transform);
                if (agents[k].transform.position == r3[rIndex[k]].transform.position)
                {
                    rIndex[k] += 1;
                }
                if (rIndex[k] == r3.Length)
                {
                    rIndex[k] = 0;
                    agents[k].SetActive(false);
                }

            }
        }
    }
}
