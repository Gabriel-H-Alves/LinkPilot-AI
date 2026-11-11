import { useState, useEffect } from 'react'
import './App.css'

function App() {
  const [serverStatus, setServerStatus] = useState('Verificando conexão...')
  const [error, setError] = useState(null)

  useEffect(() => {
    const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:5000/api'
    fetch(`${apiUrl}/health`)
      .then((res) => {
        if (!res.ok) {
          throw new Error(`HTTP error! status: ${res.status}`)
        }
        return res.json()
      })
      .then((data) => {
        setServerStatus(data.message)
      })
      .catch((err) => {
        setError(err.message)
        setServerStatus('Falha ao conectar com o backend.')
      })
  }, [])

  return (
    <main style={{ fontFamily: 'system-ui, sans-serif', padding: '2rem', textAlign: 'center' }}>
      <h1>LinkPilot AI - Ambiente de Desenvolvimento</h1>
      <p>Infraestrutura inicial configurada com sucesso.</p>
      
      <div style={{ marginTop: '2rem', padding: '1rem', border: '1px solid #ccc', borderRadius: '8px', display: 'inline-block' }}>
        <h2>Status da Comunicação com Backend:</h2>
        <p style={{ color: error ? '#d32f2f' : '#2e7d32', fontWeight: 'bold' }}>
          {serverStatus}
        </p>
      </div>
    </main>
  )
}

export default App
